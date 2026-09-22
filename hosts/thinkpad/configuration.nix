{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/core/fcitx5
    ../../modules/desktop/hyprland
    ../../modules/programs/neovim
    ../../modules/services/tailscale
    ../../modules/system/secure-boot
  ];

  networking.hostName = "thinkpad";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "25.05";
}
