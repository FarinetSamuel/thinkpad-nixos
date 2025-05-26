# Configuration de base du système

{ config, pkgs, lib, ... }:

{
  # Paramètres de base et internationalisation
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "fr_CH.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr_CH";
  };

  # Optimisations de démarrage
  systemd.services.systemd-udev-settle.enable = false;
  systemd.extraConfig = ''
    # Réduction du timeout de systemd pour accélérer le démarrage
    DefaultTimeoutStartSec=10s
    DefaultTimeoutStopSec=10s
  '';

  # Désactivation du service d'attente réseau
  systemd.services.NetworkManager-wait-online.enable = false;

  # Configuration Nix et Flakes
  nix = {
    settings = {
      # Optimisation automatique du store
      auto-optimise-store = true;

      # Activation des fonctionnalités expérimentales (flakes et nouvelle CLI)
      experimental-features = [ "nix-command" "flakes" ];

      # Trusted users (pour multi-utilisateur)
      trusted-users = [ "root" "@wheel" ];

      # Options recommandées pour les flakes
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };

    # Configuration du garbage collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Configuration du substituteur (cache binaire)
    settings.substituters = [
      "https://cache.nixos.org"
    ];
    settings.trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Permettre les packages unfree
  nixpkgs.config.allowUnfree = true;

  # Packages système de base
  environment.systemPackages = with pkgs; [
    # Outils de gestion système
    git          # Contrôle de version
    vim          # Éditeur de texte
    wget         # Téléchargement de fichiers
    curl         # Transfert de données
  ];

  # Polices système
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Polices Nerd - utilisation des nouveaux packages individuels
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono

      # Autres polices de base
      cantarell-fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      inter
      roboto
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Inter" "Roboto" "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
        monospace = [ "JetBrains Mono" "Fira Code" ];
      };
    };
  };

  # Portails XDG pour l'intégration des applications
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
