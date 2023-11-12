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

{ pkgs, lib, ... }:

{
  imports = [
    ../../common/emacs
  ];

  programs.home-manager.enable = true;

  programs.man.generateCaches = true;
  programs.info.enable = true;

  programs.git = {
    enable = true;
    userName = "Xiaoyue Chen";
    userEmail = "xchen@vvvu.org";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };

  xdg.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "skypeforlinux"
    ];

  home.packages = with pkgs; [
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science sv ]))
    firefox
    steam
  ];

  home.stateVersion = "23.05";
}
