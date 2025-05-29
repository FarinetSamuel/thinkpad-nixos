# Options du système de fichiers

{ config, pkgs, lib, ... }:

{
  # Optimisations pour les SSD
  boot.kernel.sysctl = {
    # Réduire swappiness pour améliorer les performances SSD
    "vm.swappiness" = 1;
    # Réduire la pression sur le cache pour améliorer les performances
    "vm.vfs_cache_pressure" = 50;
  };
  
  # Activations périodiques de TRIM pour les SSD
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
