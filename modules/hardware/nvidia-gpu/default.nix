{ ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # The 595 series no longer supports the GTX 10xx generation shipped in
    # older Dell G7 models. The maintained 580 branch supports both it and the
    # newer RTX variants.
    branch = "legacy_580";
    open = false;

    modesetting.enable = true;
    nvidiaPersistenced = true;
    nvidiaSettings = false;
  };
}
