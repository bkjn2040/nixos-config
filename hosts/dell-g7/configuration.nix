{ ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../modules/hardware/nvidia-gpu

      ../../modules/boot/systemd-boot.nix

      ../../modules/users/jun2040

      ../../modules/access/server-nodes.nix

      ../../modules/profiles/headless.nix

      ../../modules/roles/hardware-monitor.nix

      ../../modules/features/services/minecraft-server
    ];

  networking.hostName = "dell-g7"; # Define your hostname.

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # DO NOT CHANGE
  system.stateVersion = "25.11";
}
