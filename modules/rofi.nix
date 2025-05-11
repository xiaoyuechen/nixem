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

let
  cfg = config.nixem.rofi;

in
{
  options = {
    nixem.rofi.enable = mkEnableOption "rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      font = "mono 10";
      extraConfig = {
        modes = "windowcd,drun,run";
        dpi = 0;
        kb-accept-custom = "Alt+Return";
      };
    };
  };
}
