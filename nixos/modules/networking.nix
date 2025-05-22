# Dans networking.nix - Configuration Bluetooth consolidée
{ config, pkgs, lib, ... }:

{
  # Économie d'énergie pour le WiFi
  networking.networkmanager.wifi.powersave = true;

  # Configuration Bluetooth optimisée et centralisée
  hardware.bluetooth = {
    enable = true;

    # Utiliser bluez5-experimental pour de meilleures fonctionnalités
    package = pkgs.bluez5-experimental;

    # Ne pas démarrer automatiquement au boot (économie d'énergie)
    powerOnBoot = false;

    # Configuration avancée pour optimiser les performances
    settings = {
      General = {
        # Améliorer la compatibilité avec les périphériques
        Enable = "Source,Sink,Media,Socket";
        # Réduire la latence audio
        FastConnectable = true;
        # Optimiser la reconnexion automatique
        ReconnectAttempts = 7;
        ReconnectIntervals = "1, 2, 4, 8, 16, 32, 64";
      };

      # Optimisations pour l'audio
      Policy = {
        AutoEnable = true;
      };
    };
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
