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

  # NetworkManager simple - ne pas trop optimiser pour éviter les problèmes
  networking.networkmanager.enable = true;

  # Commentez cette ligne si vous préférez garder le pare-feu
  networking.firewall.enable = false;

  # Optimisation des polices pour démarrage plus rapide
  fonts.fontconfig.cache32Bit = true;

  # Optimisation du système de fichiers
  boot.tmp.useTmpfs = true;

  # Optimisation du montage /boot pour résoudre le problème de lenteur
  systemd.services."boot.mount" = {
    serviceConfig = {
      # Priorité plus haute pour ce service
      Nice = -10;
    };
  };

  # Ne pas oublier la version d'état
  system.stateVersion = "25.05";
}
