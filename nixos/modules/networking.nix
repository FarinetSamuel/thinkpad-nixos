# Réseau et connectivité

{ config, pkgs, lib, ... }:

{
  # Configuration réseau avec NetworkManager
  networking.networkmanager = {
    enable = true;
    # Économie d'énergie pour le WiFi
    wifi.powersave = true;
  };

  # Configuration Bluetooth complète
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # Utilisation du package expérimental pour de meilleures fonctionnalités
    package = pkgs.bluez5-experimental;
  };

  # Interface graphique pour la gestion Bluetooth
  services.blueman.enable = true;

  # Services d'impression
  services.printing.enable = true;
  
  # Firewall (activé par défaut dans NixOS)
  # networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
}
