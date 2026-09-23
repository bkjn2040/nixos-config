{ pkgs, ... }:

{
  imports = [
    ./core.nix

    ../features/desktop/hyprland

    ../features/networkmanager.nix
    ../features/system/automatic-timezone.nix
  ];

  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
