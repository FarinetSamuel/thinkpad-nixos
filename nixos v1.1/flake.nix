{
  description = "Configuration NixOS optimisée pour ThinkPad X1 Carbon Gen 6";

  inputs = {
    # Canal stable NixOS 25.05
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";

    # Canal unstable pour certains paquets récents
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations = {
      # Configuration pour le système "nixos"
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Rendre les inputs disponibles dans les modules
        specialArgs = {
          inherit inputs;
          # Import du canal unstable avec unfree activé
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };

        modules = [
          # Configuration principale
          ./hosts/thinkpad.nix

          # Révision du système pour traçabilité
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          }
        ];
      };
    };
  };
}
