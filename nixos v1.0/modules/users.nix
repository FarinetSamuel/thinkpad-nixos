# Configuration utilisateur et paquets

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  # Virtualisation avec QEMU/KVM (plus léger et performant que VirtualBox)
  virtualisation = {
    # Activer KVM et QEMU
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;  # Support TPM virtuel
        ovmf = {
          enable = true;      # Support UEFI
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };

    # Support pour les containers
    podman = {
      enable = true;
      dockerCompat = true;  # Compatibilité Docker
    };
  };

  # Modules kernel nécessaires pour KVM
  boot.kernelModules = [ "kvm-intel" "vfio-pci" ];

  # Optimisations pour la virtualisation
  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
  };

  # Configuration de l'utilisateur principal
  users.users.moi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"      # Groupe pour KVM/QEMU
      "podman"        # Groupe pour Podman
    ];
    packages = with pkgs;[
      #
      # Virtualisation et outils système
      #
      virt-manager         # Interface graphique pour KVM/QEMU
      virt-viewer          # Visualiseur de machines virtuelles
      qemu                 # Émulateur et virtualisation

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
      pkgs-unstable.gimp3
      xarchiver
      whatsapp-for-linux

      #
      # jeux
      #
      chessx

      # Packages depuis unstable (dernières versions)
      # pkgs-unstable.some-package
    ];
  };
}
