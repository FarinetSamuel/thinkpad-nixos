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
    ../modules/core/backup.nix 
    
    # Modules matériel
    ../modules/hardware/thinkpad.nix
    ../modules/hardware/power.nix
    # ../modules/hardware/power.nix  ← SUPPRIMEZ CETTE LIGNE
    
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
  
  # Version du système NixOS ne pas changer
  system.stateVersion = "24.11";
}
