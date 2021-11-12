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
  config.tfattrs =
    let
      rawState = builtins.fromJSON (builtins.readFile ../../terraform.tfstate);
    in
      builtins.foldl'
        (
          acc: {type, name, instances, ...}:
            acc // { ${type}.${name} = (head instances).attributes; }
        )
        {}
        rawState.resources;
}
