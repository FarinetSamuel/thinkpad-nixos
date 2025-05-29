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

  # Configuration touchpad consolidée et complète
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;    # Défilement naturel
      tapping = true;             # Tapotement pour clic
      disableWhileTyping = true;  # Désactivation pendant la frappe
      middleEmulation = true;     # Émulation clic milieu
      scrollMethod = "twofinger"; # Défilement à deux doigts
      clickMethod = "buttonareas"; # Zones de clic

      # Options avancées pour ThinkPad
      accelProfile = "adaptive";  # Profil d'accélération adaptatif
      accelSpeed = "0.3";         # Vitesse d'accélération modérée
    };

    # Configuration pour la souris (si utilisée)
    mouse = {
      accelProfile = "flat";      # Profil plat pour souris gaming
      middleEmulation = false;    # Pas d'émulation pour vraie souris
    };
  };

  # Activation de Flatpak pour les applications tierces
  services.flatpak.enable = true;
}
