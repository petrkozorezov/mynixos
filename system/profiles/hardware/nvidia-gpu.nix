{ config, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = false;
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    package =
      # config.boot.kernelPackages.nvidiaPackages.stable;
      # TODO убрать после фикса https://github.com/NixOS/nixpkgs/issues/429624
      config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version         = "580.65.06";
        sha256_64bit    = "sha256-BLEIZ69YXnZc+/3POe1fS9ESN1vrqwFy6qGHxqpQJP8=";
        openSha256      = "sha256-BKe6LQ1ZSrHUOSoV6UCksUE0+TIa0WcCHZv4lagfIgA=";
        settingsSha256  = "sha256-9PWmj9qG/Ms8Ol5vLQD3Dlhuw4iaFtVHNC0hSyMCU24=";
        usePersistenced = false;
      };
    # nvidiaPersistenced = true;
  };
}
