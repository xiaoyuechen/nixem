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
  nixpkgs,
  home-manager,
  emacs-overlay,
  ...
}:

let
  nixem = import ./modules;

  homeManagerConfig = {
    home-manager = {
      useUserPackages = true;
      extraSpecialArgs = {
        emacs-overlay = emacs-overlay.overlays.default;
      };
      sharedModules = [ nixem.home ];
    };
  };

  defaultConfig = {
    imports = [
      nixem.os
      home-manager.nixosModules.default
      homeManagerConfig
    ];

    nixem.fonts.enable = true;
    nixem.substituters.enable = true;
    services.fwupd.enable = true;

    console.useXkbConfig = true;

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 30;
      xkb = {
        layout = "us";
        options = "ctrl:nocaps";
      };
    };

    services.libinput.enable = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  mkNixosSystem =
    configModule:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        defaultConfig
        configModule
      ];
    };

  mkNixosConfigurations =
    hosts:
    builtins.listToAttrs (
      map (h: {
        name = h;
        value = mkNixosSystem ./hosts/${h};
      }) hosts
    );

in

mkNixosConfigurations [
  "racc"
  "enot"
]
