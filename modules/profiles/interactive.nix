{ pkgs, ... }:

{
  imports = [
    ./core.nix

    ../features/desktop/hyprland

    ../features/networking/networkmanager.nix
    ../features/system/automatic-timezone.nix
  ];

  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
