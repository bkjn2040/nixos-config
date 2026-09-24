{ ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../modules/users/jun2040

      ../../modules/access/authorized-keys.nix
      ../../modules/access/nix-trusted-users.nix
      ../../modules/access/allow-sudo-without-password.nix

      ../../modules/profiles/headless.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-TOSHIBA_MQ01UBD100_26CWSYVDS"; # or "nodev" for efi only

  networking.hostName = "satellite";

  # DO NOT CHANGE
  system.stateVersion = "25.11";
}
