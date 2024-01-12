# Copyright (C) 2024  Xiaoyue Chen
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

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.nixem.direnv;

in {
  options = {
    nixem.direnv.enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ direnv ];

    programs.bash = {
      enable = true;
      bashrcExtra = ''
        eval "$(direnv hook bash)"
      '';
    };
  };
}
