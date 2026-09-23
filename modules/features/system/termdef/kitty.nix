{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty.terminfo
  ];

  environment.extraInit = ''
    export TERMINFO_DIRS="/run/current-system/sw/share/terminfo:$TERMINFO_DIRS"
  '';
}
