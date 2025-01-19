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

{ pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./video.nix
    ./autorandr.nix
    ./wireguard.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "racc";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";
  # time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    inputMethod.enabled = "fcitx5";
    inputMethod.fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
  };

  console.useXkbConfig = true;

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];

  documentation.man.generateCaches = true;
  documentation.dev.enable = true;

  # nix.settings.substituters = [ "https://mirrors.cernet.edu.cn/nix-channels/store" ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  security.pam.services.lightdm.gnupg.enable = true;
  services.upower.enable = true;
  programs.git.enable = true;
  programs.adb.enable = true;

  hardware.nvidia.open = false;
  hardware.pulseaudio = {
    support32Bit = true;
    extraConfig = "load-module module-combine-sink";
  };
  hardware.bluetooth.enable = true;

  hardware.i2c.enable = true;

  virtualisation.libvirtd.enable = true;

  users.users.xchen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "adbusers" "kvm" ];
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
