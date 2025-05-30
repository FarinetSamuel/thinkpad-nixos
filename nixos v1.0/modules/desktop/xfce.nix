# Configuration environnement de bureau XFCE
{ config, pkgs, lib, ... }:

{
  # Serveur X et XFCE
  services.xserver = {
    enable = true;

    # Gestionnaire d'affichage LightDM
    displayManager.lightdm = {
      enable = true;
      # Thème minimaliste pour démarrage rapide
      background = "#000000";
      greeters.gtk = {
        theme = {
          name = "WhiteSur-Dark";
          package = pkgs.whitesur-gtk-theme;
        };
        iconTheme = {
          name = "WhiteSur";
          package = pkgs.whitesur-icon-theme;
        };
        cursorTheme = {
          name = "WhiteSur-cursors";
          package = pkgs.whitesur-cursors;
        };
      };
    };

    # Bureau XFCE
    desktopManager.xfce = {
      enable = true;
      # Pas de screensaver pour économiser les ressources
      enableScreensaver = false;
    };

    # Configuration clavier suisse français
    xkb = {
      layout = "ch";
      variant = "fr";
    };
  };

  # Packages XFCE additionnels
  environment.systemPackages = with pkgs; [
    # Plugins et utilitaires XFCE
    xfce.xfconf
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.xfce4-battery-plugin
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-weather-plugin
    xfce.xfce4-clipman-plugin
    xfce.xfce4-systemload-plugin

    # Archivage
    xarchiver

    # Éditeur de texte graphique
    kdePackages.kate
  ];

  # DBus optimisé
  services.dbus.implementation = "broker";
}
