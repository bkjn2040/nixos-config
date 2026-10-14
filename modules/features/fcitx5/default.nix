{ config, pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-hangul
        fcitx5-gtk
      ];
      settings.globalOptions.Behavior = {
        ActiveByDefault = false;
        PreloadInputMethod = true;
      };
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "hangul";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "keyboard-us-intl";
        "Groups/0/Items/2".Name = "hangul";
      };
      ignoreUserConfig = true;
    };
  };

  systemd.user.services.fcitx5 = {
    description = "Fcitx5 input method framework";
    documentation = [ "man:fcitx5(1)" ];
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";

    serviceConfig = {
      ExecStart = "${config.i18n.inputMethod.package}/bin/fcitx5 -D --replace";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}
