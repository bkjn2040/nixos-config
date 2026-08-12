{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "ko_KR.UTF-8/UTF-8" ];
  };

  users.users.jun2040 = {
    isNormalUser = true;
    description = "Junwoo Baek";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  environment.systemPackages = with pkgs; [
    home-manager
    neovim
  ];

  programs.git.enable = true;
}
