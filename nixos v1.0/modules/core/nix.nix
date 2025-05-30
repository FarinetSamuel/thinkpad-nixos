# Configuration du gestionnaire de paquets Nix
{ config, pkgs, lib, ... }:

{
  # Configuration Nix
  nix = {
    settings = {
      # Optimisation automatique du store
      auto-optimise-store = true;

      # Activer flakes et nouvelle interface
      experimental-features = [ "nix-command" "flakes" ];

      # Utilisateurs de confiance
      trusted-users = [ "root" "@wheel" ];

      # Options flakes
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;

      # Caches binaires
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    # Nettoyage automatique hebdomadaire
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Permettre les paquets propriétaires
  nixpkgs.config.allowUnfree = true;
}
