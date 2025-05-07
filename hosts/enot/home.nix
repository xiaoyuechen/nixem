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

{ pkgs, lib, ... }:

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
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.gnome-browser-connector
    ];
  };

  nixem.emacs.enable = true;
  nixem.email.enable = true;
  nixem.direnv.enable = true;
  nixem.python-lsp-server.enable = true;

  home.packages = with pkgs; [
    clang-tools
    nil
    rust-analyzer
    gcc
    texlive.combined.scheme-full
    python312Packages.pygments
    gdb
    git-crypt
    ripgrep
    unzip
    zip
    unrar-free
    usbutils

    gnumake.info
    gcc.info
    glibcInfo
    man-pages

    gnomeExtensions.appindicator
    gnomeExtensions.app-hider
    gnomeExtensions.brightness-control-using-ddcutil
    gnome-sound-recorder
    ddcutil

    hunspell
    hunspellDicts.en-gb-ise
    hunspellDicts.sv-se

    kdePackages.okular
    kdePackages.kdenlive
    signal-desktop
    element-desktop
    bitwarden
    transmission_4-gtk
    nextcloud-client
    libreoffice
    anki
    tor-browser-bundle-bin
    electrum
    inkscape
    vlc
    geeqie
  ];

  home.stateVersion = "23.05";
}
