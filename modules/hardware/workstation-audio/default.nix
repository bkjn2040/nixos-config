{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.qpwgraph ];

  programs.noisetorch.enable = true;

  services.pipewire = {
    enable = true;
    jack.enable = true;
    alsa.enable = true;

    wireplumber = {
      enable = true;
      extraConfig."50-disable-audio-devices"."monitor.alsa.rules" = [
        {
          matches = [
            { "device.name" = "alsa_card.pci-0000_03_00.1"; }
            {
              "device.name" =
                "alsa_card.usb-Sonix_Technology_Co.__Ltd._Logi_C270_HD_WebCam_Logi_C270_HD_WebCam-02";
            }
          ];
          actions."update-props"."device.disabled" = true;
        }
      ];
    };

    extraConfig.pipewire."90-virtual-device"."context.modules" = [
      {
        name = "libpipewire-module-loopback";
        args = {
          "node.description" = "Scarlett 2i2 Mic";
          "capture.props" = {
            "node.name" = "capture.Scarlett 2i2 Mic";
            "node.role" = "Communication";
            "audio.position" = [ "FL" ];
            "stream.dont-remix" = true;
            "target.object" = "alsa_card.pci-0000_03_00.1";
            "node.passive" = true;
          };
          "playback.props" = {
            "node.name" = "Scarlett 2i2 Mic";
            "media.class" = "Audio/Source";
            "audio.position" = [ "MONO" ];
          };
        };
      }
    ];
  };
}
