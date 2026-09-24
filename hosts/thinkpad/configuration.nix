{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/boot/secure-boot.nix

    ../../modules/users/jun2040

    ../../modules/profiles/interactive.nix

    ../../modules/roles/aarch64-emulator.nix

    ../../modules/features/fcitx5
  ];

  networking.hostName = "thinkpad";

  # DO NOT CHANGE
  system.stateVersion = "25.05";
}
