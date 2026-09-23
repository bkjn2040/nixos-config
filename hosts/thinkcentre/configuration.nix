{ ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../modules/users/jun2040

      ../../modules/access/server-nodes.nix

      ../../modules/profiles/headless.nix

      ../../modules/roles/service-manager.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkcentre"; # Define your hostname.

  # DO NOT CHANGE
  system.stateVersion = "25.11";
}
