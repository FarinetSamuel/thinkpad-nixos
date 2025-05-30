# Configuration de l'utilisateur principal
{ config, pkgs, lib, ... }:

{
  users.users.moi = {
    isNormalUser = true;
    description = "Utilisateur principal";

    # Groupes système nécessaires
    extraGroups = [
      "wheel"           # Administration système
      "networkmanager"  # Gestion réseau
      "libvirtd"        # Virtualisation KVM
      "podman"          # Conteneurs
      "audio"           # Accès audio
      "video"           # Accès vidéo
    ];

    # Shell par défaut
    shell = pkgs.bash;
  };

  # Sudo sans mot de passe pour wheel (optionnel)
  # security.sudo.wheelNeedsPassword = false;
}
