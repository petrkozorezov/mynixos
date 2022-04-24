#
# TODO:
#  - add device existence validation
#
{ lib, slib, file, ... }:
with lib;
with builtins;
rec {
  types = with lib.types; rec {
    extra =
      submodule { options = {
        attrs   = mkOption { type = slib.xml.types.attrs          ; default = {}; };
        content = mkOption { type = listOf slib.xml.types.elements; default = []; };
      };};

    device =
      submodule { options = {
        id      = mkOption { type = str  ; };
        enable  = mkOption { type = bool ; default = false    ; };
        name    = mkOption { type = str  ; };
        address = mkOption { type = str  ; default = "default"; };
        extra   = mkOption { type = extra; default = {}       ; };
      };};

    syncType = enum [ "sendonly" "receiveonly" "sendreceive" ];
    folder =
      submodule { options = {
        id      = mkOption { type = str       ; };
        enable  = mkOption { type = bool      ; default = false        ; };
        label   = mkOption { type = str       ; };
        path    = mkOption { type = str       ; };
        devices = mkOption { type = listOf str; default = []           ; };
        type    = mkOption { type = syncType  ; default = "sendreceive"; };
        extra   = mkOption { type = extra     ; default = {}           ; };
      };};

    gui =
      submodule { options = {
        enable    = mkOption { type = bool ; default = true ; };
        tls       = mkOption { type = bool ; default = true ; };
        debugging = mkOption { type = bool ; default = false; };
        address   = mkOption { type = str  ; default = "127.0.0.1:8384"; };
        apiKey    = mkOption { type = str  ; default = ""              ; };
        extra     = mkOption { type = extra; default = {}; };
      };};

    options = attrs;

    config =
      submodule { options = {
        version = mkOption { type = int          ; default = 35; };
        devices = mkOption { type = listOf device; default = []; };
        folders = mkOption { type = listOf folder; default = []; };
        options = mkOption { type = options      ; default = {}; };
        gui     = mkOption { type = gui          ; default = {}; };
        extra   = mkOption { type = extra        ; default = {}; };
      };};
  };

  format = with slib.xml.dsl; {
    extra =
      self: {tag, attrs, content}:
        element tag (attrs // self.attrs) (content ++ self.content);

    device =
      {id, enable, name, address, extra}:
        format.extra extra (
          element "device" { inherit id name; } [
            (element "address"           {} address  )
            (element "paused"            {} (!enable))
          ]
        );

    folder =
      {id, enable, label, path, devices, type, extra}:
        format.extra extra (
          element "folder" { inherit id label type path; } (
            (map
              (deviceId: (element "device" { id = deviceId; } []))
              devices
            ) ++ [
              (element "paused" {} (!enable))
            ]
          )
        );

    gui =
      self:
        format.extra self.extra (
          element "gui" {
            enabled   = self.enable;
            tls       = self.tls;
            debugging = self.debugging;
          } [
            (element "address" {} self.address)
            (element "apikey"  {} self.apiKey )
          ]
        );

    options =
      self:
        element "options" {} (mapAttrsToList (name: value: element name {} value) self); # TODO toString

    config =
      self:
        document
          (declaration {})
          (format.extra self.extra (
            element "configuration" { version = self.version; } (
              (map format.device self.devices) ++
              (map format.folder self.folders) ++
              [
                (format.gui     self.gui    )
                (format.options self.options)
              ]
          )));

    configStr =
      config: slib.xml.format.document (format.config config);
  };

  tests = {
    simple =
      let
        config =
          let
            A = "AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA";
            B = "BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB";
          in {
            devices = [
              {
                id      = A;
                name    = "A";
                address = "192.168.1.1";
              }
              {
                id      = B;
                name    = "B";
                address = "192.168.1.2";
              }
            ];
            folders = [
              {
                id      = "test";
                label   = "Test";
                path    = "~/Test";
                type    = "receiveonly";
                devices = [ A B ];
              }
            ];
            gui = {
              enable = true;
              apiKey = "dMZRRin5oHpT6Q";
            };
            options.listenAddress = "localhost:4242";
          };
      in
        slib.tests.assertVal
          (slib.xml.format.document (format.config (slib.utils.evalOpt file types.config config)))
          ''
            <?xml encoding="UTF-8" version="1.0"?>
            <configuration version="35">
              <device id="AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA" name="A">
                <address>192.168.1.1</address>
                <paused>true</paused>
              </device>
              <device id="BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB" name="B">
                <address>192.168.1.2</address>
                <paused>true</paused>
              </device>
              <folder id="test" label="Test" path="~/Test" type="receiveonly">
                <device id="AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA-AAAAAAA">
                </device>
                <device id="BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB-BBBBBBB">
                </device>
                <paused>true</paused>
              </folder>
              <gui debugging="false" enabled="true" tls="true">
                <address>127.0.0.1:8384</address>
                <apikey>dMZRRin5oHpT6Q</apikey>
              </gui>
              <options>
                <listenAddress>localhost:4242</listenAddress>
              </options>
            </configuration>
          ''
        ;
  };
}
