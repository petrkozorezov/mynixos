{ pkgs, ... }: {
   home.packages = with pkgs; [
    easyeffects # простое конфигурирование эффктов в pipewire
  ];
}
