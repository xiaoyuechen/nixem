{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixem.desktopManager;

in
{
  options = {
    nixem.desktopManager = {
      xmonad.enable = mkEnableOption "xmonad desktop environment";
    };
  };

  config = mkMerge [
    (mkIf cfg.xmonad.enable {
      xsession.enable = true;
      xsession.preferStatusNotifierItems = true;
      xsession.profileExtra = ''
        autorandr -c
        status-notifier-watcher &
        fcitx5 --enable all &
      '';

      nixem.xmonad.enable = true;
      nixem.taffybar.enable = true;
      nixem.picom.enable = true;
      nixem.rofi.enable = true;
      services.xscreensaver.enable = true;

      home.packages = with pkgs; [
        adwaita-icon-theme
        gnome-themes-extra
        gnome-screenshot
        gnomeExtensions.appindicator
        haskellPackages.status-notifier-item
        brightnessctl
        pulsemixer
      ];
    })
  ];
}
