{ pkgs, ... }:

{
  imports = [
    ./core.nix
    
    ../features/system/termdef/kitty.nix

    ../features/services/avahi.nix
  ];

  users.users.jun2040.packages = [ pkgs.tree ];
}
