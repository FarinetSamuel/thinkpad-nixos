{
  description = "Configuration NixOS pour ThinkPad X1 Carbon Gen 6";

  # Définition des sources externes
  inputs = {
    # Nixpkgs stable (24.11)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Pour les dernières versions de certains paquets
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home-manager pour une gestion plus fine de la configuration utilisateur (optionnel)
    # home-manager = {
    #   url = "github:nix-community/home-manager/release-24.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # Définition des outputs du flake
  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    # Définition de la configuration NixOS
    nixosConfigurations = {
      # Remplacez "nixos" par votre hostname si différent
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          # Rendre le canal unstable disponible dans les modules
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          # Configuration principale pour ce système
          ./hosts/thinkpad.nix

          # Pour la rétrocompatibilité avec nixos-rebuild (sans --flake)
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          }
        ];
      };
    };
  };
}
