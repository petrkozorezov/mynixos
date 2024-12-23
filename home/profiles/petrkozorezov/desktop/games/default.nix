{ pkgs, ... }: {
  imports = [
    ./mangohud.nix
    ./vkquake.nix
  ];

  # steam args
  # https://gist.github.com/davispuh/6600880

  # run command
  # gamescope --expose-wayland --prefer-vk-device 1002:7480 -W 2560 -H 1600 -r 144 --rt -f -F fsr -- mangohud steam -bigpicture
}


