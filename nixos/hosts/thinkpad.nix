# Configuration spécifique au ThinkPad X1 Carbon Gen 6

{ config, pkgs, lib, inputs, pkgs-unstable, ... }:

{
  imports = [
    # Inclure la configuration matérielle générée
    ../hardware-configuration.nix
    
    # Importer les modules modulaires
    ../modules/base.nix
    ../modules/hardware.nix
    ../modules/networking.nix
    ../modules/desktop.nix
    ../modules/multimedia.nix
    ../modules/services.nix
    ../modules/users.nix
    ../modules/backup.nix
  ];

  # Configuration spécifique au ThinkPad X1 Carbon Gen 6
  networking.hostName = "nixos";
  
  # Optimisation pour les SSD - alternative à la modification directe du système de fichiers
  boot.kernel.sysctl = {
    "vm.swappiness" = 1;
    "vm.vfs_cache_pressure" = 50;
  };
  
  # Ne pas oublier la version d'état
  system.stateVersion = "24.11";
}
