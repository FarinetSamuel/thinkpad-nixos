# Configuration utilisateur et paquets

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  # Configuration de l'utilisateur principal
  users.users.moi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs;[
      #
      # Applications système
      #
      kdePackages.kate     # Éditeur de texte avancé
      fastfetch            # Information système rapide
      btop                 # Moniteur système moderne
      htop                 # Moniteur système classique
      lm_sensors           # Capteurs matériels

      #
      # Multimédia et productivité
      #
      vlc                  # Lecteur multimédia
      brave                # Navigateur web sécurisé
      libreoffice-fresh    # Suite bureautique
      
      #
      # Environnement Xfce et extensions
      #
      xfce.xfconf
      xfce.thunar
      xfce.xfce4-battery-plugin
      xfce.xfce4-pulseaudio-plugin
      xfce.xfce4-whiskermenu-plugin
      xfce.xfce4-weather-plugin
      xfce.xfce4-clipman-plugin
      xfce.xfce4-systemload-plugin
      xfce.thunar-archive-plugin
      
      #
      # Thèmes et apparence
      #
      whitesur-icon-theme
      whitesur-gtk-theme
      whitesur-cursors

      #
      # Connectivité et cloud
      #
      dropbox
      bluez
      bluez-tools
      blueman

      #
      # Autres applications
      #
      pkgs-unstable.alpaca
      pkgs-unstable.virtualbox
      pkgs-unstable.gimp3
      xarchiver
      whatsapp-for-linux

      # Packages depuis unstable (dernières versions)
      # Exemple:
      # pkgs-unstable.some-package
    ];
  };
}
