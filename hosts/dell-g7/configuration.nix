{ ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../modules/users/jun2040

      ../../modules/access/server-nodes.nix

      ../../modules/profiles/headless.nix

      ../../modules/hardware/nvidia-gpu

      ../../modules/features/services/minecraft-server
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dell-g7"; # Define your hostname.

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # DO NOT CHANGE
  system.stateVersion = "25.11";
}
