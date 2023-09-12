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

{ pkgs, ... }: {
  imports =
    [
      ./hardware-configuration.nix
      ./video.nix
      ./cachix.nix
      ./autorandr.nix
      ./picom.nix
      ./xmonad.nix
      ./emacs.nix
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
  documentation.man.man-db.enable = true;
  documentation.dev.enable = true;

  # nix.settings.substituters = [ "https://mirrors.cernet.edu.cn/nix-channels/store" ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    libinput.enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";
    autoRepeatDelay = 200;
    autoRepeatInterval = 30;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    liberation_ttf
  ];

  services.xserver.displayManager.lightdm.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  security.pam.services.lightdm.gnupg.enable = true;
  services.upower.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  hardware.i2c.enable = true;

  virtualisation.libvirtd.enable = true;

  users.users.xchen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    gnome.gnome-screenshot
    gnomeExtensions.appindicator
    xscreensaver
    brightnessctl
    okular
    firefox
    glibcInfo
    autoconf
    gcc
    rofi
    mu
    isync
    fetchmail_7
    libsecret
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science sv ]))
    nextcloud-client
    taffybar
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
    authy
    virt-manager
    tor-browser-bundle-bin
    skypeforlinux
    telegram-desktop
    transmission-gtk
    libreoffice
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };

  programs.git.enable = true;
  programs.seahorse.enable = true;
  programs.steam.enable = true;

  xdg.mime.defaultApplications = {
    "application/pdf" = "org.kde.okular.desktop";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
