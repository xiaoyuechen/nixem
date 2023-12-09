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
    pinentryFlavor = "gnome3";
  };

  xdg.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
    };
  };

  nixem.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };
  nixem.email.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "skypeforlinux"
      "zoom"
    ];

  home.packages = with pkgs; [
    direnv
    git-crypt

    gcc
    gsl
    clang-tools_16

    python3Packages.python-lsp-server
    nil
    rust-analyzer

    texlive.combined.scheme-full

    gnumake.info
    gcc.info
    glibcInfo
    man-pages

    firefox
    signal-desktop
    libreoffice

    steam
    skypeforlinux
    zoom-us
  ];

  home.stateVersion = "23.05";
}
