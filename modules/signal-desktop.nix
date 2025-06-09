# Copyright (C) 2025  Xiaoyue Chen
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixem.signal-desktop;

in
{
  options = {
    nixem.signal-desktop.enable = mkEnableOption "signal-desktop";
    nixem.signal-desktop.instance = mkOption {
      type = types.ints.positive;
      default = 1;
      example = 2;
      description = "Number of Signal instances.";
    };
  };

  config = let
    makeSignalDesktopItem = with pkgs; i:
      let wrapper = writeShellScript "signal-wrapper" ''
        exec ${signal-desktop.meta.mainProgram} --user-data-dir="$HOME/.config/Signal${toString i}" "$@"
      ''; in makeDesktopItem {
        name = "signal-${toString i}";
        desktopName = "Signal ${toString i}";
        exec = "${wrapper} %U";
        type = "Application";
        terminal = false;
        icon = "signal-desktop";
        comment = "Private messaging from your desktop";
        startupWMClass = "signal";
        mimeTypes = [
          "x-scheme-handler/sgnl"
          "x-scheme-handler/signalcaptcha"
        ];
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
      };
  in
    mkMerge [
      (mkIf cfg.enable {
        home.packages = [ pkgs.signal-desktop ];
      })
      (mkIf (cfg.instance > 1) {
        home.packages = builtins.genList
          (i: makeSignalDesktopItem (i + 2))
          (cfg.instance - 1);
      })
    ];
}
