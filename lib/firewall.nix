#
# DSL to generate 'iptables' commands.
# The main purpose is to be able to:
#  - express only valid commands and rules and show errors on nix stage;
#  - use nix modules system to construct rules.
#
{ lib, file, slib, ... }:
with lib;
with builtins;
rec {
  not = v: [ "!" v ];
  isNegative = x: (isList x) && (length x == 2) && (elemAt x 0 == "!");

  types = with lib.types; rec {
    # TODO port ranges
    # TODO check address
    # TODO per-target options
    subm  = options: submodule { inherit options; };
    tree  = listOf (oneOf [ str (listOf tree) ]);
    extra = mkOption { type = tree; default = []; };
    table = enum [ "filter" "nat" "mangle" "raw" "security" ];

    negated =
      t:
        mkOptionType rec {
          name        = "negated";
          description = "negated ${t.description}";
          check = x: isNegative x && t.check (elemAt x 1) || t.check x;
          merge =
            loc: defs:
              let isneg = isNegative (head defs).value;
              in if all (v: (isNegative v.value) == isneg) (tail defs) then
                if !isneg then
                  t.merge loc defs
                else
                  [ "!" (t.merge loc (map ({file, value}: { inherit file; value = elemAt value 1; }) defs)) ]
              else
                throw "The option `${options.showOption loc}' has conflicting definition values:${options.showDefs defs}";
          typeMerge = f':
            abort "${name}.typeMerge is unimplemented";
          functor =
            abort "${name}.functor is unimplemented";
          nestedTypes = t;
        };

    tagged =
      elements:
        mkOptionType rec {
          name = "tagged";
          description = "tagged ${attrNames elements}";
          check =
            x@{name, value}:
              if hasAttr x.name elements then elements.${x.name}.check x.value else false;
          merge =
            loc: defs:
              let hd = (head defs).value;
              in if all (def: def.value.name == hd.name) (tail defs) then
                nameValuePair hd.name (
                  elements.${hd.name}.merge
                    loc (map (
                      {file, value}:
                        { inherit file; inherit (value) value; }
                    ) defs)
                )
              else
                throw "The option `${options.showOption loc}' has conflicting definition values:${options.showDefs defs}";
          typeMerge = f':
            abort "${name}.typeMerge is unimplemented";
            # let
              # m1 = lists.zipLists(attrNames attrs)
              # mts = map ({fst, snd}: fst.typeMerge snd) (lists.zipLists ((attrValues elements) f'.wrapped));
            # in
              # if (name == f'.name) && (all (v: v != null) mts) then
              #   functor.type mts
              # else
              #   null;
          functor =
            abort "${name}.functor is unimplemented";
            # {
            #   inherit name;
            #   type    = tagged;
            #   payload = null;
            #   binOp   = a: b: null;
            #   wrapped = attrValues elements;
            # };
          nestedTypes = elements;
        };

    addressInterface = subm {
      addresses = mkOption { type = nullOr (negated (listOf str)); default = null; };
      interface = mkOption { type = nullOr (negated         str ); default = null; };
      extra     = extra;
    };

    matchStates = listOf (enum [ "NEW" "ESTABLISHED" "RELATED" "INVALID" ]);
    matchLimit = subm {
      value  = mkOption { type = int;                                     };
      period = mkOption { type = enum [ "second" "minute" "hour" "day" ]; };
      burst  = mkOption { type = nullOr int; default = null;              };
    };
    match = subm {
      states = mkOption { type = nullOr matchStates; default = null; };
      limit  = mkOption { type = nullOr matchLimit ; default = null; };
      mac    = mkOption { type = nullOr str        ; default = null; };
      extra  = extra;
    };

    protocolTCPFlag  = enum ["ACK" "FIN" "PSH" "RST" "SYN" "URG" "ALL" "NONE"];
    protocolTCPFlags = subm {
      tested = mkOption { type = listOf protocolTCPFlag; };
      set    = mkOption { type = listOf protocolTCPFlag; };
    };
    protocolTCP = subm {
      srcPort  = mkOption { type = nullOr str             ; default = null; };
      destPort = mkOption { type = nullOr str             ; default = null; };
      # syn      = mkOption { type = nullOr bool            ; default = null; }; # TODO взаимоисключающее с syn
      flags    = mkOption { type = nullOr protocolTCPFlags; default = null; };
      options  = mkOption { type = nullOr str             ; default = null; };
    };
    protocolUDP = subm {
      destPort = mkOption { type = nullOr str; default = null; };
      srcPort  = mkOption { type = nullOr str; default = null; };
    };

    protocolICMP = subm {
      type = mkOption { type = nullOr str; default = null; };
    };

    # TODO "icmpv6" "esp" "ah" "sctp" "mh" "udplite"
    protocol = tagged {
      tcp   = protocolTCP ;
      udp   = protocolUDP ;
      icmp  = protocolICMP;
      extra = extra;
    };

    spec = subm {
      from        = mkOption { type = nullOr addressInterface  ; default = null ; };
      to          = mkOption { type = nullOr addressInterface  ; default = null ; };
      match       = mkOption { type = nullOr match             ; default = null ; };
      protocol    = mkOption { type = nullOr (negated protocol); default = null ; };
      fragment    = mkOption { type = nullOr bool              ; default = null ; };
      extra       = extra;
    };

    command =
      tagged (
        let
          tableOpt = mkOption { type = nullOr table; default = null; };
          chainCmd = subm {
            table = tableOpt;
            chain = mkOption { type = str; };
          };
          ruleCmd = subm {
            table  = tableOpt;
            chain  = mkOption { type = str ; };
            spec   = mkOption { type = spec; default = {}; };
            next   = mkOption { type = enum [ "jump" "goto" ]; default = "jump"; };
            target = mkOption { type = str ; };
          };
      in {
        new-chain     = chainCmd;
        flush-chain   = chainCmd;
        zero-chain    = chainCmd;
        delete-chains = subm {
          table  = tableOpt;
          chains = mkOption { type = listOf str; };
        };
        rename-chain = subm {
          table = tableOpt;
          from  = mkOption { type = str; };
          to    = mkOption { type = str; };
        };
        change-chain-policy = subm {
          table  = tableOpt;
          chain  = mkOption { type = str; };
          target = mkOption { type = str; };
        };
        append-rule  = ruleCmd;
        insert-rule  = ruleCmd;
        check-rule   = ruleCmd;
        delete-rules = ruleCmd;
        extra        = extra;
      });
  };

  format = let
    ifAttr = name: set: fun: (if set.${name} != null then (fun set.${name}) else []);
    fcomp = a: b: c: (a (b c));
    commaSeparated = concatStringsSep ",";
    value   = prefix: v : [ prefix v ];
    values  = prefix: vs: [ prefix (commaSeparated vs) ];
    int     = prefix: i : value prefix (toString i);
    flag    = flg: v: if v then [ flg ] else [ "!" flg ];
    reduceNeg = v: if isNegative v && isNegative (elemAt v 1) then reduceNeg (elemAt (elemAt v 1) 1) else v;
    negated =
      f: v:
        let v' = reduceNeg v;
        in if isNegative v' then [ "!" (f (elemAt v' 1)) ] else (f v');
  in rec {

    addressFrom   = values "-s";
    addressTo     = values "-d";
    interfaceFrom = value  "-i";
    interfaceTo   = value  "-o";

    addressInterfaceFrom =
      addrif:
        ifAttr "addresses" addrif (negated addressFrom  ) ++
        ifAttr "interface" addrif (negated interfaceFrom) ++
        addrif.extra;
    addressInterfaceTo =
      addrif:
        ifAttr "addresses" addrif (negated addressTo  ) ++
        ifAttr "interface" addrif (negated interfaceTo) ++
        addrif.extra;

    matchStates = values [ "-m" "state" "--state" ];
    matchLimit  =
      lmt:
        [ "-m" "limit" "--limit" "${toString lmt.value}/${lmt.period}"] ++
        ifAttr "burst" lmt (v: [ "--limit-burst" (toString v) ]);
    match =
      mtch:
        ifAttr "states" mtch matchStates ++
        ifAttr "limit"  mtch matchLimit ++
        mtch.extra;

    protocolTPCFlags = flgs: [ "--tcp-flags" (commaSeparated flgs.tested) (commaSeparated flgs.set) ];
    protocolTCP =
      tcp:
        ifAttr "srcPort"  tcp (value    "--sport"       ) ++
        ifAttr "destPort" tcp (value    "--dport"       ) ++
        # ifAttr "syn"      tcp (flag     "--syn"         ) ++
        ifAttr "flags"    tcp  protocolTPCFlags           ++
        ifAttr "options"  tcp (value    "--tcp-option"  );

    protocolUDP =
      udp:
        ifAttr "destPort" udp (value "--dport") ++
        ifAttr  "srcPort" udp (value "--sport");

    protocolICMP =
      icmp:
        ifAttr "type" icmp (value "--icmp-type"); # values ?

    protocol =
      proto:
        [ "-p" proto.name (
          if proto.name == "tcp"   then protocolTCP  proto.value else
          if proto.name == "udp"   then protocolUDP  proto.value else
          if proto.name == "icmp"  then protocolICMP proto.value else
          if proto.name == "extra" then proto.value              else
          abort "Unknown protocol ${proto.name}"
        ) ];

    fragment = flag "-f";

    spec =
      s:
        ifAttr "from"        s addressInterfaceFrom ++
        ifAttr "to"          s addressInterfaceTo   ++
        ifAttr "match"       s match                ++
        ifAttr "protocol"    s (negated protocol)   ++
        ifAttr "fragment"    s fragment             ++
        s.extra;

    command =
      let
        next =
          v:
            if v == "jump" then "-j" else
            if v == "goto" then "-g" else
            abort "Unknown next: ${v}";
        ruleCommand =
          prefix: {value, ...}:
            [ prefix value.chain (spec value.spec) (next value.next) value.target ];
      in cmd@{name, value, ...}:
          (if value.table != null then [ "-t" value.table ] else []) ++ (
          if name == "new-chain"           then [ "-N" value.chain                   ] else
          if name == "flush-chain"         then [ "-F" value.chain                   ] else
          if name == "zero-chain"          then [ "-Z" value.chain                   ] else
          if name == "delete-chains"       then [ "-X" value.chains                  ] else
          if name == "rename-chain"        then [ "-R" value.from value.to           ] else
          if name == "change-chain-policy" then [ "-P" value.chain value.target      ] else
          if name == "append-rule"         then ruleCommand "-A" cmd                   else
          if name == "insert-rule"         then ruleCommand "-I" cmd                   else
          if name == "check-rule"          then ruleCommand "-C" cmd                   else
          if name == "delete-rules"        then ruleCommand "-D" cmd                   else
          if name == "extra"               then value.extra                            else
          abort "Unknown command: ${name}");

    treeToStr = asList: concatStringsSep " " (lists.flatten asList);
    toStr     = formatter: data: treeToStr (formatter data);
    optToStr  = formatter: type: data: toStr formatter (evalOpt type data);
  };
  command =
    name: cmd:
      format.optToStr format.command types.command (nameValuePair name cmd);

  evalOpt = slib.utils.evalOpt file;

  tests =
    {
      spec =
        let
          spec = {
            from = {
              addresses = [ "10.2.1.1" "10.2.1.2" ];
              interface = "eth1";
            };
            to = {
              addresses = [ "10.2.2.1" "10.2.2.2" ];
              interface = "eth3";
            };
            match = { states = [ "NEW" ]; limit = { value = 10; period = "minute"; }; };
            fragment = false;
            protocol = not { name = "tcp"; value = {
              destPort = "42";
              flags    = { tested = [ "ACK" "FIN" "SYN" ]; set = [ "SYN" ]; };
              options  = "42";
            }; };
          };
        in
          slib.tests.assertVal
            # (format.spec (slib.utils.evalOpt file types.spec spec)) ''
            (format.optToStr format.spec types.spec spec) (replaceStrings [ "\n" ] [ " " ] ''
              -s 10.2.1.1,10.2.1.2
              -i eth1
              -d 10.2.2.1,10.2.2.2
              -o eth3
              -m state --state NEW
              -m limit --limit 10/minute
              ! -p tcp --dport 42 --tcp-flags ACK,FIN,SYN SYN --tcp-option 42
              ! -f'');

      command =
          let
            command =
              nameValuePair "append-rule" {
                table  = "filter";
                chain  = "testChain";
                spec   = {
                  from = {
                    addresses = not [ "10.2.1.1" ];
                  };
                };
                target = "testTarget";
              };
          in
            slib.tests.assertVal
              (format.optToStr format.command types.command command)
              "-t filter -A testChain ! -s 10.2.1.1 -j testTarget";

  };
}

