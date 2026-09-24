{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/users/jun2040

    ../../modules/access/authorized-keys.nix
    ../../modules/access/nix-trusted-users.nix
    ../../modules/access/allow-sudo-without-password.nix

    ../../modules/profiles/headless.nix
  ];

  boot.initrd.availableKernelModules = {
    dw-hdmi = lib.mkForce false;
    dw-mipi-dsi = lib.mkForce false;
    rockchipdrm = lib.mkForce false;
    rockchip-rga = lib.mkForce false;
    phy-rockchip-pcie = lib.mkForce false;
    pcie-rockchip-host = lib.mkForce false;
    pwm-sun4i = lib.mkForce false;
    sun4i-drm = lib.mkForce false;
    sun8i-mixer = lib.mkForce false;
  };

  networking = {
    hostName = "rspi4";

    # Obtain an address automatically from your router.
    useDHCP = true;
  };

  environment.systemPackages = with pkgs; [
    ethtool
    wakeonlan
  ];

  # Helpful because your Pi 4 has 2 GB RAM.
  zramSwap.enable = true;

  hardware.raspberry-pi.firmware = {
    enable = true;
    uboot.enable = true;
  };

  # DO NOT CHANGE
  system.stateVersion = "26.05";
}
