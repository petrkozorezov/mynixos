{ pkgs, ... }:
{
  hardware.opengl = {
    enable          = true;
    driSupport      = true;
    driSupport32Bit = true;
    extraPackages   = with pkgs              ; [ amdvlk ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ amdvlk libva ];
  };
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
  programs.steam.enable = true;
}
