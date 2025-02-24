{ lib, config, options, ... }:
with lib; {
  options.tfattrs =
    mkOption {
      type    = types.attrs; # FIXME
      default = {};
      description = ''
        Local terraform state attributes
      '';
    };
  # TODO describe structure
  config.tfattrs =
    let
      rawState = builtins.fromJSON (builtins.readFile ../../terraform.tfstate);
    in
      builtins.foldl'
        (
          acc: {type, name, instances, ...}:
            lib.attrsets.recursiveUpdate acc { ${type}.${name} = (head instances).attributes; }
        )
        {}
        rawState.resources;
}
