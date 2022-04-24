#
# TODO:
#  - secrets?
#  - tests
#  - config type
#  - sway as systemd service && tray
#
# TODO:
#  - declarative cluster config
#  - syncthing server config
#  - syncthing desktop config
#  - start sway with systemd
#  - syncthing tray
#  - mobile device config.xml
#  -
#

      # devices = {
      #   helsinki1 = {
      #     id = "DGVV7YN-NMHCEHP-JKNNHUM-O5JX3PY-NXICCG7-TI7W7EE-GDFDTKJ-6Z2Z4QM";
      #     cert = ''
      #       MIICHTCCAaOgAwIBAgIJAOlzJh2/uOFdMAoGCCqGSM49BAMCMEoxEjAQBgNVBAoT
      #       CVN5bmN0aGluZzEgMB4GA1UECxMXQXV0b21hdGljYWxseSBHZW5lcmF0ZWQxEjAQ
      #       BgNVBAMTCXN5bmN0aGluZzAeFw0yMjAzMjIwMDAwMDBaFw00MjAzMTcwMDAwMDBa
      #       MEoxEjAQBgNVBAoTCVN5bmN0aGluZzEgMB4GA1UECxMXQXV0b21hdGljYWxseSBH
      #       ZW5lcmF0ZWQxEjAQBgNVBAMTCXN5bmN0aGluZzB2MBAGByqGSM49AgEGBSuBBAAi
      #       A2IABGwx/lnLTHVQBydyyirEBSTWTdF+Ct/cE5vpVdOUyyHcuUOOQsDXdrq0M5U8
      #       Cn3QE45cDF6c//UvZC5A4UZ5C2sBJTrd/gibmzYZKO/ZLNCZQRFm3P8XKe4gW4ca
      #       4AViNaNVMFMwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggr
      #       BgEFBQcDAjAMBgNVHRMBAf8EAjAAMBQGA1UdEQQNMAuCCXN5bmN0aGluZzAKBggq
      #       hkjOPQQDAgNoADBlAjEA1pEhQ6F1M30z3C0WtODSJmjd2N/IumwwDNf5lovbcdr8
      #       nJi3tC/YxKSpJZHGBkU/AjADs5kRdqZpNMu8egKphwgCnL0S2rAye/eEjRDtGUao
      #       aIENRar29Gky+MbfOj/KVNU=
      #     '';
      #     key = ''
      #       MIGkAgEBBDCJrDf0qxFqagUclym2juADQJs1FeJt7JnlaUZTF2vmw3K0FbCct8yy
      #       v+KgofosoY+gBwYFK4EEACKhZANiAARsMf5Zy0x1UAcncsoqxAUk1k3Rfgrf3BOb
      #       6VXTlMsh3LlDjkLA13a6tDOVPAp90BOOXAxenP/1L2QuQOFGeQtrASU63f4Im5s2
      #       GSjv2SzQmUERZtz/FynuIFuHGuAFYjU=
      #     '';
      #     address = "";
      #   };
      #   # mbp13 = {
      #   #   cert = ;
      #   #   key  = ;
      #   #   address = ;
      #   # };
      #   galaxy-s20u = "PU2QGSL-EX4CMMZ-KH47AU6-MM7ZX2B-3AZKM4C-RJWOIZB-BWO6MKA-X4L3WA6";
      # };
      # folders = {
      #   "Photos/s20u" = # id, label, path
      #     {
      #       # id    = <name>;
      #       # label = <name>;
      #       # path  = <name>;
      #       type = "oneway"; #
      #       from = [ {
      #         host = "galaxy-s20u";
      #         path = "aoeuaoeua";
      #       } ];
      #       to = [
      #         { host = "mbp13"; }
      #         {
      #           host     = "helsinki1";
      #           password = password;
      #         }
      #       ];
      #     };
      #     "Documents" = {
      #       type = "twoway";
      #       hosts = [
      #         { host = "mbp13"; }
      #         { host = "helsinki1"; password = password; }
      #         { host = "asrock-x300"; }
      #       ];
      #     };
      #         # { type = "twoway"; hosts = [ { host = "galaxy-s20u"; path = "aoeuaoeua"; } "mbp13" ]; }
      # };

{ slib, lib }:
with lib; rec {
  types = with lib.types; rec {
    sync = attrsOf (oneOf [ str sync ]);

    devices =
      attrsOf (submodule ({ name, config, ... }: { options = {
        id       = mkOption { type = str; };
        cert     = mkOption { type = str; };
        certFile = mkOption { type = path; default = builtins.toFile "syncthing-${name}-cert" config.cert; };
        key      = mkOption { type = str; };
        keyFile  = mkOption { type = path; default = builtins.toFile "syncthing-${name}-key" config.key; };
        path     = mkOption { type = str; default = cfg.path; };
        address  = mkOption { type = str; default = "default"; };
        # extra
      }; }));
    folders =
      attrsOf (submodule ({ name, config, ... }: { options = {
        id    = mkOption { type = str; default = name; };
        label = mkOption { type = str; default = name; };
        path  = mkOption { type = str; default = name; };
        devices = ;
        sync  = mkOption { type = sync; };
        # extra
      }; }));
    configuration =
      submodule { options = {
        path = mkOption { type = str; };
        inherit devices folders;
        # extra
      };};
  };

  dsl = {
    sync   = foldl deepmerge {};
    oneway = from: to: { ${from} = sync to; };
    twoway = waysList: todo mult;
  };

  host = home: config: {
    services = ;
    secrets =
      lib.foldr
        (
          acc: secret:
            acc // {
              "syncthing-${secret}" = {
                source    = "text";
                target    = "${home}/${secret}";
                dependent = [ "syncthing.service" ];
              };
            }
        )
        {}
        [ "cert.pem" "key.pem" ];
    files."config.xml" = slib.xml.format.document (format.config config);
  };
}

  # configPath = xdg.configHome + "/syncthing";
  # dataPath   = "~/syncthing";
  # options    = "--data=\"${dataPath}\" --config=\"${configPath}\" --no-upgrade --no-default-folder";

  # sss.user.secrets =
  #   lib.foldr
  #     (
  #       acc: secret:
  #         acc // {
  #           "syncthing-${secret}" = {
  #             source    = "text";
  #             target    = "${configPath}/${secret}";
  #             dependent = [ "syncthing.service" ];
  #           };
  #         }
  #     )
  #     {}
  #     [ "cert.pem" "key.pem" ];

  # home.file."${configPath}/config.xml".text = with slib;
  #   xml.format.document (syncthing.format.config (
  #     let
  #       mbp13       = "DGVV7YN-NMHCEHP-JKNNHUM-O5JX3PY-NXICCG7-TI7W7EE-GDFDTKJ-6Z2Z4QM";
  #       galaxy-s20u = "PU2QGSL-EX4CMMZ-KH47AU6-MM7ZX2B-3AZKM4C-RJWOIZB-BWO6MKA-X4L3WA6";
  #       deviceExtra = {
  #         attrs   = { compression = "metadata"; introducer = false; };
  #         content = xml.dsl.element "autoAcceptFolders" {} false;
  #       };
  #     in {
  #       devices = [
  #         {
  #           id      = mbp13;
  #           name    = "MacBook Pro 13";
  #           address = "192.168.4.6";
  #           extra   = deviceExtra;
  #         }
  #         {
  #           id      = galaxy-s20u;
  #           name    = "Galaxy S20 Ultra";
  #           address = "192.168.4.2";
  #           extra   = deviceExtra;
  #         }
  #       ];
  #       folders = [
  #         {
  #           id      = "sm-g9880_bgee-photos";
  #           label   = "Camera";
  #           path    = dataPath + "/camera";
  #           type    = "receiveonly";
  #           devices = [ mbp13 galaxy-s20u ];
  #         }
  #       ];
  #       gui = {
  #         enable  = true;
  #         tls     = false;
  #         address = "127.0.0.1:8384";
  #         apiKey  = "dMZRRin5oHpT6QC9zeFMqZmacuDHZECS";
  #       };
  #       options = {
  #         listenAddress         = "192.168.4.6";
  #         globalAnnounceEnabled = false        ;
  #         localAnnounceEnabled  = false        ;
  #         relaysEnabled         = false        ;
  #         startBrowser          = false        ;
  #         natEnabled            = false        ;
  #         crashReportingEnabled = false        ;
  #         crashReportingEnabled = false        ;
  #       };
  #     }
  #   ));


    # with slib.xml; format.document (evalOpt types.document (with dsl;
    #   let
    #     device = id: name: address:
    #       (element "device" { inherit id name; compression = "metadata"; introducer = "false"; } [
    #         (element "address"           {} address)
    #         (element "paused"            {} "false")
    #         (element "autoAcceptFolders" {} "false")
    #       ]);
    #     folder = id: label: path: type: devices:
    #       let
    #         devicesElements =
    #           map
    #             (deviceId:
    #               (element "device" { id = deviceId; } [])
    #             )
    #             devices;
    #       in
    #         (element "folder" { inherit id label type; path = rootPath + "/" + path; } devicesElements);


    # with slib.xml; format.document (evalOpt types.document (with dsl;
    #   let
    #     device = id: name: address:
    #       (element "device" { inherit id name; compression = "metadata"; introducer = "false"; } [
    #         (element "address"           {} address)
    #         (element "paused"            {} "false")
    #         (element "autoAcceptFolders" {} "false")
    #       ]);
    #     folder = id: label: path: type: devices:
    #       let
    #         devicesElements =
    #           map
    #             (deviceId:
    #               (element "device" { id = deviceId; } [])
    #             )
    #             devices;
    #       in
    #         (element "folder" { inherit id label type; path = rootPath + "/" + path; } devicesElements);

    #     mbp13       = "DGVV7YN-NMHCEHP-JKNNHUM-O5JX3PY-NXICCG7-TI7W7EE-GDFDTKJ-6Z2Z4QM";
    #     galaxy-s20u = "PU2QGSL-EX4CMMZ-KH47AU6-MM7ZX2B-3AZKM4C-RJWOIZB-BWO6MKA-X4L3WA6";
    #   in
    #     document
    #       (declaration {})
    #       (element "configuration" { version = "35"; } [
    #         (device {
    #           id      = mbp13;
    #           name    = "MacBook Pro 13";
    #           address = "192.168.4.6";
    #         })
    #         (device {
    #           id      = galaxy-s20u;
    #           name    = "Galaxy S20 Ultra";
    #           address = "192.168.4.2";
    #         })
    #         (folder {
    #           id      = "sm-g9880_bgee-photos";
    #           label   = "Camera";
    #           path    = "camera";
    #           type    = "receiveonly";
    #           devices = [ mbp13 galaxy-s20u ];
    #         })
    #         (element "gui" { enabled = "true"; tls = "false"; debugging = "false"; } [
    #           (element "address" {} "127.0.0.1:8384"                  )
    #           (element "apikey"  {} "dMZRRin5oHpT6QC9zeFMqZmacuDHZECS")
    #         ])
    #         (element "options" {} [
    #           (element "listenAddress"         {} "192.168.4.6")
    #           (element "globalAnnounceEnabled" {} "false"      )
    #           (element "localAnnounceEnabled"  {} "false"      )
    #           (element "relaysEnabled"         {} "false"      )
    #           (element "startBrowser"          {} "false"      )
    #           (element "natEnabled"            {} "false"      )
    #           (element "crashReportingEnabled" {} "false"      )
    #           (element "crashReportingEnabled" {} "false"      )
    #         ])
    #       ])
    # ));




  # services = {
  #   syncthing = {
  #     enable = true;

  #     cert = ;
  #     key  = ;

  #     overrideDevices  = true;
  #     overrideFolders  = true;
  #     openDefaultPorts = false;

  #     devices = {
  #       "helsinki1" = {
  #         id         = "P3S5A5S-HS2BQM5-IVBXZOB-KVKSXRY-FBNI7EH-R3IIN4C-QLH3LDF-4QSIEAI";
  #         addresses  = [ "tcp://${net}.1" ];
  #       };
  #       "mbp13" = {
  #         id        = "DEVICE-ID-GOES-HERE";
  #         addresses = [ "tcp://${net}.6" ];
  #       };
  #       "galaxy-s20u" = {
  #         id        = "PU2QGSL-EX4CMMZ-KH47AU6-MM7ZX2B-3AZKM4C-RJWOIZB-BWO6MKA-X4L3WA6";
  #         addresses = [ "tcp://${net}.2" ];
  #       };
  #     };
  #     folders = {
  #       "Photos" = {
  #         path      = rootPath + "/Photos";
  #         devices   = [ "mbp13" "galaxy-s20u" ];
  #       };
  #     };
  #   };
  # };

  # networking.firewall.interfaces."wg0".allowedTCPPorts = [ port ];

  # sss.secrets =
  #   let
  #     path = config.zoo.secrets.filesPath + "syncthing/${config.hostname}/";
  #     secrets = {
  #       cert = path + "cert.pem";
  #       key  = path + "key.pem" ;
  #     };
  #   in
  #     builtins.mapAttrs' (
  #       name: source:
  #         nameValuePair
  #           ("syncthing-" + name)
  #           {
  #             inherit source;
  #             user              = "syncthing";
  #             service.dependent = [ "syncthing.service" ];
  #           }
  #     ) secrets;

