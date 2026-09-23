{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/users/jun2040

    ../../modules/profiles/interactive.nix

    ../../modules/roles/aarch64-emulator.nix

    ../../modules/features/fcitx5
    ../../modules/features/desktop/hyprland
    ../../modules/features/system/secure-boot
  ];

  networking.hostName = "thinkpad";

  # DO NOT CHANGE
  system.stateVersion = "25.05";
}
