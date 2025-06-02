# Configuration réseau et connectivité
{ config, pkgs, lib, ... }:

{
  # NetworkManager pour gestion réseau simple
  networking = {
    networkmanager = {
      enable = true;
      # WiFi en mode économie d'énergie
      wifi.powersave = true;
    };

    # DNS rapides
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    # Pare-feu désactivé (à activer si besoin)
    firewall.enable = false;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    # Package avec fonctionnalités expérimentales
    package = pkgs.bluez5-experimental;
    # Désactivé au démarrage (économie d'énergie)
    powerOnBoot = false;

    # Configuration optimisée
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        FastConnectable = true;
        ReconnectAttempts = 7;
        ReconnectIntervals = "1,2,4,8,16,32,64";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Interface graphique Bluetooth
  services.blueman.enable = true;

  # Services d'impression (désactivé par défaut)
  # services.printing.enable = true;
}
