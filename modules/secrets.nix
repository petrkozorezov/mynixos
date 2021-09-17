#
# Secrets interface declaration.
#
{ lib, config, pkgs, ... }:
with lib;
{
  options = {
    zoo.secrets = {

      users = mkOption {
        type = types.attrsOf (types.submodule ({ name, ... }: {
          options = {

            name = mkOption {
              example     = "user";
              default     = name;
              type        = types.str;
              description = "User name.";
            };

            hashedPassword = mkOption {
              type        = types.str;
              description = "Hashed password for the user, see users.users.<name>.hashedPassword.";
            };
            authPublicKey = mkOption {
              type        = types.str;
              description = "SSH authorization public key.";
            };
            # TODO gnupgPubring;

          };
        }));
        default     = {};
        description = "Users secrets.";
      };

      vpn = mkOption {
        type = types.attrsOf (types.submodule ({ name, ... }: {
          options = {

            name = mkOption {
              example     = "user";
              default     = name;
              type        = types.str;
              description = "Name of the keys pair.";
            };

            priv = mkOption {
              type        = types.str;
              description = "Private key.";
            };
            pub = mkOption {
              type        = types.str;
              description = "Public key.";
            };
            addr = mkOption {
              type        = types.str;
              description = "VPN network address postfix";
            };

          };
        }));
        default     = {};
        description = "Keys for VPN.";
      };

      wifi = mkOption {
        type = types.attrsOf (types.submodule ({ name, ... }: {
          options = {

            name = mkOption {
              example     = "zoo";
              default     = name;
              type        = types.str;
              description = "SSID of wifi network.";
            };

            passphrase = mkOption {
              type        = types.str;
              description = "Wifi network passphrase.";
            };

          };
        }));
        default     = {};
        description = "Security settings for the wifi networks.";
      };

      others = mkOption {
        type        = types.attrs;
        default     = {};
        description = "Not strictly specified secrets.";
      };

    };
  };
}
