# Interface graphique et environnement de bureau

{ config, pkgs, lib, ... }:

{
  # Configuration du serveur X
  services.xserver = {
    enable = true;

    # Gestionnaire d'affichage LightDM
    displayManager.lightdm.enable = true;

    # Environnement de bureau XFCE
    desktopManager.xfce.enable = true;

    # Configuration clavier suisse français
    xkb = {
      layout = "ch";
      variant = "fr";
    };
  };

  # Configuration touchpad
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;  # Défilement naturel
      tapping = true;           # Tapotement
      disableWhileTyping = true; # Désactivation pendant la frappe
    };
  };

  # Activation de Flatpak pour les applications tierces
  services.flatpak.enable = true;
}
