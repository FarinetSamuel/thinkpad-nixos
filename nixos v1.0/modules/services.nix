# Services système

{ config, pkgs, lib, ... }:

{
  # Services spécifiques au système
  # Note: libinput est maintenant configuré dans desktop.nix

  # Exemple d'autres services système que vous pourriez ajouter :

  # # Service de localisation (optionnel)
  # services.geoclue2.enable = true;

  # # Service d'indexation de fichiers (optionnel)
  # services.locate = {
  #   enable = true;
  #   locate = pkgs.mlocate;
  #   interval = "daily";
  # };

  # # Service de notifications système
  # services.gnome.at-spi2-core.enable = true;
}
