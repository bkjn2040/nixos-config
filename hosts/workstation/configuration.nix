{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/hardware/amd-gpu
    ../../modules/hardware/workstation-audio

    ../../modules/users/jun2040

    ../../modules/profiles/interactive.nix

    ../../modules/roles/audio-workstation.nix
    ../../modules/roles/aarch64-emulator.nix

    ../../modules/features/fcitx5
    ../../modules/features/localisation/korean-fonts
    ../../modules/features/services/ollama-rocm
    ../../modules/features/system/secure-boot
  ];

  networking.hostName = "nixos";

  # DO NOT CHANGE
  system.stateVersion = "25.11";
}
