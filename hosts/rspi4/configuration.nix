{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/services/tailscale
  ];

  nix.settings.trusted-users = [
    "root"
    "jun2040"
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

  services.openssh = {
    enable = true;
    openFirewall = true;

    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.jun2040 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keyFiles = [
      ../../modules/services/ssh/keys/id_ed25519_personal_thinkpad.pub
      ../../modules/services/ssh/keys/id_ed25519_personal_workstation.pub
    ];
  };

  # SSH-key possession effectively controls administrative access.
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    ethtool
    wakeonlan
    kitty.terminfo
  ];

  environment.extraInit = ''
    export TERMINFO_DIRS="/run/current-system/sw/share/terminfo:$TERMINFO_DIRS"
  '';

  # Helpful because your Pi 4 has 2 GB RAM.
  zramSwap.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  hardware.raspberry-pi.firmware = {
    enable = true;
    uboot.enable = true;
  };

  system.stateVersion = "26.05";
}
