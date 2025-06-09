# Copyright (C) 2023, 2024, 2025  Xiaoyue Chen
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

let
  osModules = [
    ./fonts.nix
    ./substituters.nix
    ./printing.nix
  ];

  hmModules = [
    ./emacs.nix
    ./email.nix
    ./picom.nix
    ./rofi.nix
    ./taffybar.nix
    ./xmonad.nix
    ./desktop-manager.nix
    ./direnv.nix
    ./python-lsp-server.nix
    ./signal-desktop.nix
  ];

in
{
  os = {
    imports = osModules;
  };
  home = {
    imports = hmModules;
  };
}
