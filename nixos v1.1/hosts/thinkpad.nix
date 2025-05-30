# Configuration principale pour ThinkPad X1 Carbon Gen 6
{ config, pkgs, lib, inputs, pkgs-unstable, ... }:

{
  imports = [
    # Configuration matérielle générée automatiquement
    ../hardware-configuration.nix
    
    # Modules système de base
    ../modules/core/system.nix
    ../modules/core/boot.nix
    ../modules/core/nix.nix
    
    # Modules matériel
    ../modules/hardware/thinkpad.nix
    ../modules/hardware/power.nix
    
    # Modules bureau
    ../modules/desktop/xfce.nix
    ../modules/desktop/fonts.nix
    
    # Services système
    ../modules/services/networking.nix
    ../modules/services/multimedia.nix
    ../modules/services/virtualisation.nix
    
    # Configuration utilisateur
    ../modules/users/moi.nix
    ../modules/users/packages.nix
  ];

  # Nom du système
  networking.hostName = "nixos";
  
  # Version du système NixOS
  system.stateVersion = "25.05";
}
