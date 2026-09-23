{ pkgs, ... }:

{
  imports = [
    ../features/system/time

    ../features/programs/neovim
    ../features/programs/git.nix

    ../features/services/ssh
    ../features/services/tailscale
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "ko_KR.UTF-8/UTF-8" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl
    wget
  ];

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
}
