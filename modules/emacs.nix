# Copyright (C) 2023, 2024  Xiaoyue Chen
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
  emacs-overlay,
  ...
}:

with lib;

let
  cfg = config.nixem.emacs;

in
{
  options = {
    nixem.emacs.enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ emacs-overlay ];

    programs.emacs = {
      enable = true;
      package =
        with pkgs;
        (emacsWithPackagesFromUsePackage {
          config = ./emacs.el;
          defaultInitFile = true;
          package = emacs-unstable;
        });
    };

    services.emacs = {
      enable = true;
      package = config.programs.emacs.package;
      defaultEditor = true;
      client.enable = true;
      startWithUserSession = "graphical";
    };

    programs.bash = {
      enable = true;
      bashrcExtra = ''
        if [[ "$INSIDE_EMACS" = 'vterm' ]] \
            && [[ -n ''${EMACS_VTERM_PATH} ]] \
            && [[ -f ''${EMACS_VTERM_PATH}/etc/emacs-vterm-bash.sh ]]; then
        	source ''${EMACS_VTERM_PATH}/etc/emacs-vterm-bash.sh
        fi
      '';
    };
  };
}
