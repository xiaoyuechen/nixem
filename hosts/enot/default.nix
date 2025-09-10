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

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [ apfs ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "enot";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
    };
  };

  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true;

  documentation.man.generateCaches = true;
  documentation.dev.enable = true;

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };

  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  services.gnome.gnome-browser-connector.enable = true;

  services.pulseaudio.support32Bit = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.dictd =
    with pkgs;
    let
      swe2eng = stdenv.mkDerivation rec {
        name = "dctd-db-swe2eng";
        src = fetchurl {
          url = "https://download.freedict.org/dictionaries/swe-eng/0.2/freedict-swe-eng-0.2.dictd.tar.xz";
          sha256 = "Y/cvh2fBN4Mo9T8e0co2hk1By5w9VKfOibtTHhgv+o4=";
        };
        unpackPhase = ''
          tar xf  ${src}
        '';
        installPhase = ''
          mkdir -p $out/share/dictd
          cp $(ls ./swe-eng/*.{dict*,index} || true) $out/share/dictd
          echo "sv_SV" >$out/share/dictd/locale
        '';
      };
    in
    {
      enable = true;
      DBs = [ swe2eng dictdDBs.wiktionary];
    };

  programs.git.enable = true;
  programs.adb.enable = true;

  nixem.printing.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "hplip"
    ];

  users.users.xchen = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "adbusers"
      "kvm"
    ];
  };

  home-manager.users.xchen = import ./home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
