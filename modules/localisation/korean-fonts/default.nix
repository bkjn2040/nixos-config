{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nanum
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
    fontconfig.defaultFonts = {
      serif = [ "NanumMyeongjo" ];
      sansSerif = [ "NanumGothic" ];
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
    };
  };
}
