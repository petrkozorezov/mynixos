{ pkgs, testing, ... }: testing.makeTest (let
  path = "/run/keys";
  name = "test-secret";
  text = "my secret";
  target      = "${path}/${name}";
  service     = "systemd-${name}";
  rootService = "multi-user.target";
in {

  name = "sss";

  machine =
    { config, pkgs, ... }: {
      sss = {
        enable = true;
        inherit path;
        commands = let rev = "${pkgs.util-linux}/bin/rev"; in {
          encrypt = rev;
          decrypt = rev;
        };
        secrets.${name} = {
          inherit text service;
          dependent = [ rootService ];
        };
      };
    };

  testScript =
    ''
      machine.wait_for_unit("${rootService}")

      with subtest("Read secret"):
        machine.succeed("A=$(cat ${target}); test \"$A\" = \"${text}\"")

      with subtest("Stop secret service"):
        machine.systemctl("stop ${service}")
        machine.fail("[ -f ${target} ]")
    '';
})
