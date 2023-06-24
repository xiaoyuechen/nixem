{
  inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";

  outputs = { self, nixpkgs, emacs-overlay }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    nixosConfigurations.racc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit emacs-overlay; };

      modules = [ ./configuration.nix ];
    };
  };
}
