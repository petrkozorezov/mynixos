{ lib, ... }:
with lib;
with builtins;
with types;
{
  types = rec {
    # TODO better name
    tree = listOf (oneOf [ str (listOf tree) ]);
    address = submodule { options = {
      address   = mkOption { type = nullOr str ; default = null; };
      port      = mkOption { type = nullOr port; default = null; };
      interface = mkOption { type = nullOr str ; default = null; };
      extra     = mkOption { type = nullOr tree; default = null; };
    }; };
    match = submodule { options = {
      # TODO limit
      states = mkOption { type = nullOr (listOf (enum [ "NEW" "ESTABLISHED" "RELATED" "INVALID" ])); default = null; };
      extra  = mkOption { type = nullOr tree; default = null; };
    }; };
    filter = submodule { options = {
      from     = mkOption { type = nullOr address; default = null; };
      to       = mkOption { type = nullOr address; default = null; };
      match    = mkOption { type = nullOr match  ; default = null; };
      # # TODO protocol with specific options
      protocol = mkOption { type = nullOr (enum [ "tcp" "udp" "udplite" "icmp" "icmpv6" "esp" "ah" "sctp" "mh" ]); default = null; };
      extra    = mkOption { type = nullOr tree; default = null; };
    }; };

    # TODO
    # rule = {
    #   filter = filter;
    #   action = { jump = ; goto = ; };
    # };
  };

  format = let
    ifAttr = name: set: fun: (if set.${name} != null then (fun set.${name}) else []);
  in rec {
    filterAddressFrom =
      filter:
        ifAttr "address"   filter (value: [ "-s"      value ]) ++
        ifAttr "interface" filter (value: [ "-i"      value ]) ++
        ifAttr "port"      filter (value: [ "--sport" value ]) ++
        ifAttr "extra"     filter (value: value);

    filterAddressTo =
      filter:
        ifAttr "address"   filter (value: [ "-d"       value ]) ++
        ifAttr "interface" filter (value: [ "-o"       value ]) ++
        ifAttr "port"      filter (value: [ "--dsport" value ]) ++
        ifAttr "extra"     filter (value: value);

    filterMatch =
      # is it possible to use multiple matches
      match:
        ifAttr "states" match (value: [ "-m state --state" (concatStringsSep "," value) ]) ++
        ifAttr "extra"  match (value: value);

    filter =
      filter:
        ifAttr "from"     filter (value: filterAddressFrom value) ++
        ifAttr "to"       filter (value: filterAddressTo   value) ++
        ifAttr "match"    filter (value: filterMatch       value) ++
        ifAttr "protocol" filter (value: [ "-p" value ]) ++
        ifAttr "extra"    filter (value: value    );
  };

  treeToString = asList: concatStringsSep " " (lists.flatten asList);
}
