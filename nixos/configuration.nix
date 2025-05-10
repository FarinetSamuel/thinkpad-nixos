# Ce fichier est maintenu pour la rétrocompatibilité avec des commandes comme
# `sudo nixos-rebuild switch` (sans --flake)

{ config, pkgs, ... }:

{
  imports = [ ./hosts/thinkpad.nix ];
}
