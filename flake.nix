{
  description = "NixOS configurations for a home network";

  inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, emacs-overlay, home-manager }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations.racc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // {
          cachix = import ./cachix.nix;
          nixem = import ./common;
        };
        modules = [ ./hosts/racc ];
      };

      nixosConfigurations.enot = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ ./hosts/enot ];
      };
    };
}
