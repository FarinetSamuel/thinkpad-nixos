# Environnement XFCE avec sécurité et interface NixOS

{ config, pkgs, lib, ... }:

{
  # Configuration du serveur X
  services.xserver = {
    enable = true;

    # Gestionnaire d'affichage LightDM avec interface NixOS
    displayManager.lightdm = {
      enable = true;

      # Greeter GTK standard de NixOS
      greeters.gtk = {
        enable = true;
        theme = {
          package = pkgs.whitesur-gtk-theme;
          name = "WhiteSur-Dark";
        };
        iconTheme = {
          package = pkgs.whitesur-icon-theme;
          name = "WhiteSur";
        };
        cursorTheme = {
          package = pkgs.whitesur-cursors;
          name = "WhiteSur-cursors";
        };
        # Configuration pour conserver l'apparence NixOS
        extraConfig = ''
          # Fond d'écran NixOS
          background = /run/current-system/sw/share/pixmaps/nixos-logo.png
          theme-name = WhiteSur-Dark
          icon-theme-name = WhiteSur
          font-name = Inter 11
          xft-antialias = true
          xft-dpi = 96
          xft-hinting = true
          xft-rgba = rgb
          show-language-selector = false
          show-indicators = ~language;~session;~power
          show-clock = true
          clock-format = %H:%M
          # Garder l'interface utilisateur standard
          show-user-list = true
          hide-user-image = false
        '';
      };
    };

    # Environnement de bureau XFCE
    desktopManager.xfce.enable = true;

    # Configuration clavier suisse français
    xkb = {
      layout = "ch";
      variant = "fr";
    };
  };

  # Configuration touchpad pour ThinkPad
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      middleEmulation = true;
      scrollMethod = "twofinger";
      clickMethod = "buttonareas";
      accelProfile = "adaptive";
      accelSpeed = "0.3";
    };
    mouse = {
      accelProfile = "flat";
      middleEmulation = false;
    };
  };

  # Packages XFCE et sécurité
  environment.systemPackages = with pkgs; [
    # Composants XFCE essentiels
    xfce.xfconf
    xfce.thunar
    xfce.xfce4-battery-plugin
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-weather-plugin
    xfce.xfce4-clipman-plugin
    xfce.xfce4-systemload-plugin
    xfce.thunar-archive-plugin

    # Sécurité et verrouillage d'écran
    xfce.xfce4-screensaver
    xfce.xfce4-power-manager

    # Thèmes
    whitesur-icon-theme
    whitesur-gtk-theme
    whitesur-cursors
  ];

  # Configuration PAM pour authentification sécurisée
  security.pam.services = {
    lightdm.enableGnomeKeyring = true;
    xfce4-screensaver = {};  # Support authentification écran de verrouillage
  };

  # Support Flatpak
  services.flatpak.enable = true;

  # Service pour écran de verrouillage automatique
  systemd.user.services.xfce4-screensaver = {
    description = "XFCE4 Screen Saver";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.xfce.xfce4-screensaver}/bin/xfce4-screensaver";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # Configuration pour verrouillage automatique à la mise en veille
  services.logind = {
    lidSwitch = "suspend";
    powerKey = "poweroff";
    powerKeyLongPress = "poweroff";
    extraConfig = ''
      # Verrouiller l'écran avant la mise en veille
      HandleLidSwitch=suspend
      HandlePowerKey=poweroff
      IdleAction=lock
      IdleActionSec=600
    '';
  };

  # Script de démarrage pour configurer l'écran de verrouillage
  system.userActivationScripts.xfce-screensaver-config = ''
    # Configuration automatique de xfce4-screensaver
    if [ -n "$DISPLAY" ]; then
      # Activer l'écran de verrouillage
      ${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-screensaver -p /saver/enabled -s true -t bool 2>/dev/null || true
      ${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-screensaver -p /lock/enabled -s true -t bool 2>/dev/null || true
      ${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-screensaver -p /lock/saver-activation/enabled -s true -t bool 2>/dev/null || true
      ${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-screensaver -p /lock/saver-activation/delay -s 10 -t int 2>/dev/null || true

      # Configuration power manager
      ${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lock-screen-suspend-hibernate -s true -t bool 2>/dev/null || true
      ${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch -s true -t bool 2>/dev/null || true
    fi
  '';
}
