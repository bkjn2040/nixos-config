{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/core/fcitx5
    ../../modules/desktop/hyprland
    ../../modules/hardware/amd-gpu
    ../../modules/hardware/workstation-audio
    ../../modules/localisation/korean-fonts
    ../../modules/services/ollama-rocm
    ../../modules/services/tailscale
    ../../modules/system/secure-boot
  ];

  networking = {
    hostName = "nixos";
    extraHosts = ''
      192.168.1.167 homelab
    '';
  };

  users.users.jun2040.extraGroups = [
    "audio"
    "jackaudio"
    "realtime"
    "wireshark"
  ];

  system.stateVersion = "25.11";
}
