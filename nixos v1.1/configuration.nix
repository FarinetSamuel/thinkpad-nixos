# Fichier de rétrocompatibilité pour nixos-rebuild sans --flake
{ config, pkgs, ... }:

{
  imports = [ ./hosts/thinkpad.nix ];
}
