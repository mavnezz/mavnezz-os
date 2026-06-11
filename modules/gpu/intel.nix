{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.gpu.intel;
in
{
  options.workstation.gpu.intel.enable =
    lib.mkEnableOption "Intel iGPU drivers (VA-API + VDPAU)";

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
