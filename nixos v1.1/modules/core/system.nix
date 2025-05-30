# Configuration système de base et localisation
{ config, pkgs, lib, ... }:

{
  # Localisation Suisse francophone
  time.timeZone = "Europe/Zurich";

  i18n = {
    defaultLocale = "fr_CH.UTF-8";
    supportedLocales = [ "fr_CH.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  # Configuration console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr_CH";
  };

  # Packages système essentiels
  environment.systemPackages = with pkgs; [
    # Outils de base indispensables
    git          # Contrôle de version
    vim          # Éditeur de texte
    wget         # Téléchargement HTTP
    curl         # Client HTTP polyvalent
    htop         # Moniteur système
    btop         # Moniteur système moderne
  ];

  # Portails XDG pour l'intégration desktop
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Support Flatpak pour applications tierces
  services.flatpak.enable = true;

  # Scripts de sauvegarde
  system.activationScripts.createBackupDir = ''
    mkdir -p /etc/nixos/scripts
  '';

  # Script de sauvegarde automatique
  environment.etc."nixos/scripts/backup-nixos.sh" = {
    source = ../../scripts/backup-nixos.sh;
    mode = "0755";
  };

  # Service de sauvegarde hebdomadaire
  systemd.services.nixos-config-backup = {
    description = "Sauvegarde automatique de la configuration NixOS";
    startAt = "weekly";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/etc/nixos/scripts/backup-nixos.sh";
    };
  };
}
