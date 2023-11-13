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

{ config, pkgs, lib, ... }:

{
  imports = [
    ../../common/picom
    ../../common/xmonad
    ../../common/emacs
    ../../common/mail
  ];

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
    pinentryFlavor = "gtk2";
  };

  xdg.enable = true;

  xsession.enable = true;
  xsession.preferStatusNotifierItems = true;
  xsession.profileExtra = ''
    autorandr -c
    status-notifier-watcher &
    fcitx5 --enable all &
  '';

  services.taffybar.enable = true;

  services.xscreensaver.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "skypeforlinux"
    ];

  home.packages = with pkgs; [
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    gnome.gnome-screenshot
    gnome.seahorse
    gnomeExtensions.appindicator
    brightnessctl
    okular
    firefox
    glibcInfo
    gnumake
    autoconf
    gcc
    gdb
    clang-tools_16
    rofi
    isync
    libsecret
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science sv ]))
    haskellPackages.status-notifier-item
    haskellPackages.hoogle
    pulsemixer
    direnv
    ddcutil
    signal-desktop
    xscreensaver
    unzip
    nil
    nssTools
    nixops_unstable
    gimp
    git-crypt
    texlive.combined.scheme-full
    virt-manager
    telegram-desktop
    skypeforlinux
    transmission-gtk
    libreoffice
    steam
  ];

  home.stateVersion = "23.05";
}
