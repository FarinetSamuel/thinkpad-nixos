# Réseau et connectivité

{ config, pkgs, lib, ... }:

{
  # Économie d'énergie pour le WiFi
  networking.networkmanager.wifi.powersave = true;

  # Configuration Bluetooth
  hardware.bluetooth = {
    enable = true;
    # Utilisation du package expérimental pour de meilleures fonctionnalités
    package = pkgs.bluez5-experimental;
  };

  # Interface graphique pour la gestion Bluetooth
  services.blueman.enable = true;

  # Services d'impression - désactivé pour accélérer le démarrage
  # Décommentez si vous avez besoin d'imprimer
  services.printing.enable = false;

  # Configurer le résolveur DNS pour un démarrage plus rapide
  networking = {
    # Utiliser un DNS rapide
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };
}
