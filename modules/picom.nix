# Copyright (C) 2023  Xiaoyue Chen
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

{ config, lib, ... }:

with lib;

let cfg = config.nixem.picom;

in {
  options = {
    nixem.picom.enable = mkEnableOption "picom";
  };

  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      backend = "glx";
      fade = true;
      fadeSteps = [ 0.16 0.02 ];
      fadeDelta = 2;
      inactiveOpacity = 0.8;
      opacityRules = [ "100:class_g = 'Rofi'" ];
      shadow = true;
      vSync = true;

      settings = {
        inactive-opacity-override = false;
        corner-radius = 8;
        glx-no-stencil = true;
        shadow-exclude = [ "class_g = 'firefox' && argb" ];
      };
    };
  };
}
