# Configuration système de base et localisation
{ config, pkgs, lib, ... }:

{

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
