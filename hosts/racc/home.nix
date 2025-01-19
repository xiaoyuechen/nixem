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

{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;

  programs.man.generateCaches = true;
  programs.info.enable = true;

  programs.git = {
    enable = true;
    userName = "Xiaoyue Chen";
    userEmail = "xchen@vvvu.org";
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  xdg.enable = true;

  nixem.desktopManager.xmonad.enable = true;
  nixem.emacs.enable = true;
  nixem.email.enable = true;
  nixem.direnv.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "steam-run"
      "skypeforlinux"
    ];

  home.packages = with pkgs; [
    glibcInfo
    gnumake
    autoconf
    gcc
    gdb
    clang-tools_16
    git-crypt
    haskellPackages.hoogle
    haskell-language-server
    nil
    unzip
    nssTools
    ddcutil
    usbutils
    texlive.combined.scheme-full

    okular
    firefox
    signal-desktop
    gimp
    virt-manager
    telegram-desktop
    skypeforlinux
    transmission-gtk
    libreoffice
    steam
  ];

  home.stateVersion = "23.05";
}
