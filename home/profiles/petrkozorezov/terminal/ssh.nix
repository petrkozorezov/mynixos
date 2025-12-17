{ config, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # TODO remove in future
    matchBlocks =
      # for ordering use dag functions see
      # https://github.com/nix-community/home-manager/blob/cb17f1ede2fe777c1d879dc99c8d242a80985ff2/doc/release-notes/rl-2003.adoc
      let
        sshConfigHome = "~/.ssh/";
        matchBlock = extra: {
            identitiesOnly = true;
            identityFile = sshConfigHome + "id_rsa_ybk1.pub";
          } // extra;
      in {
        "*" = {
          forwardAgent        = true;
          addKeysToAgent      = "no";
          compression         = false;
          serverAliveInterval = 300;
          serverAliveCountMax = 2;
          hashKnownHosts      = true;
          userKnownHostsFile  = "~/.ssh/known_hosts";
          controlMaster       = "no";
          controlPath         = "~/.ssh/master-%r@%n:%p";
          controlPersist      = "no";
        };
        "github.com" = matchBlock {};
      };

    extraConfig =
      ''
          User ${config.home.username}
          # AddKeysToAgent yes
          AddressFamily inet
          #VisualHostKey yes
          PasswordAuthentication no
          ChallengeResponseAuthentication no
          StrictHostKeyChecking ask
          VerifyHostKeyDNS yes

          ForwardX11 no
          ForwardX11Trusted no

          Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
          MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
          KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
          HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa

          ControlMaster auto
          ControlPath ~/.ssh/master-%r@%h:%p
          ControlPersist 10m
      '';
  };
}
