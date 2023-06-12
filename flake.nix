{
  inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";

  outputs = { self, nixpkgs, emacs-overlay }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    nixosConfigurations.racc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules =
        [
          ({ config, pkgs, ... }: {
            imports =
              [
                ./hardware-configuration.nix
                ./cachix.nix
                ./autorandr.nix
                ./picom.nix
                ./xmonad.nix
                (import ./emacs.nix emacs-overlay)
                ./wireguard.nix
              ];

            # Use the systemd-boot EFI boot loader.
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            networking.hostName = "racc";
            networking.networkmanager.enable = true;

            # Set your time zone.
            time.timeZone = "Europe/Stockholm";

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

            # Enable the X11 windowing system.
            services.xserver = {
              enable = true;
              libinput.enable = true;
              layout = "us";
              xkbOptions = "ctrl:nocaps";
              autoRepeatDelay = 200;
              autoRepeatInterval = 30;
            };

            fonts.fonts = with pkgs; [
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
            services.gnome.at-spi2-core.enable = true;

            # Use the evil nvidia driver
            nixpkgs.config.allowUnfree = true;
            services.xserver.videoDrivers = [ "nvidia" ];
            hardware.opengl.enable = true;
            hardware.opengl.driSupport32Bit = true;
            hardware.nvidia.prime = {
              sync.enable = true;
              intelBusId = "PCI:0:2:0";
              nvidiaBusId = "PCI:1:0:0";
            };

            hardware.i2c.enable = true;

            sound.enable = true;
            hardware.pulseaudio.enable = true;

            users.users.xchen = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
            };

            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            environment.sessionVariables = rec {
              XDG_CACHE_HOME = "$HOME/.cache";
              XDG_CONFIG_HOME = "$HOME/.config";
              XDG_DATA_HOME = "$HOME/.local/share";
              XDG_STATE_HOME = "$HOME/.local/state";
            };

            services.upower.enable = true;

            # List packages installed in system profile. To search, run:
            # $ nix search wget
            environment.systemPackages = with pkgs; [
              gnome.adwaita-icon-theme
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
              ispell
              nextcloud-client
              taffybar
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
          })
        ];
    };
  };
}
