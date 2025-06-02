# Configuration du démarrage et optimisations
{ config, pkgs, lib, ... }:

{
  boot = {
    # Utiliser systemd-boot (plus rapide que GRUB)
    loader = {
      systemd-boot = {
        enable = true;
        # Nombre d'entrées à conserver
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      # Timeout minimal pour démarrage rapide
      timeout = 1;
    };

    # Noyau Linux récent pour meilleures performances
    kernelPackages = pkgs.linuxPackages_latest;

    # Paramètres kernel optimisés pour démarrage rapide
    kernelParams = [
      # Mode silencieux
      "quiet"
      "loglevel=0"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"

      # Optimisations Intel
      "intel_pstate=passive"
      "i915.fastboot=1"

      # Optimisations disque
      "rootflags=noatime"
    ];

    # Compression initrd optimisée
    initrd = {
      compressor = "zstd";
      compressorArgs = [ "-19" "-T0" ];
    };

    # Modules kernel nécessaires
    kernelModules = [ "kvm-intel" ];

    # Configuration modules additionnels
    extraModprobeConfig = ''
      # Virtualisation imbriquée pour KVM
      options kvm_intel nested=1
      # Économie d'énergie WiFi Intel
      options iwlwifi power_save=1
    '';

    # Utiliser tmpfs pour /tmp (plus rapide)
    tmp.useTmpfs = true;

    # Optimisations sysctl
    kernel.sysctl = {
      # Réduire l'utilisation du swap
      "vm.swappiness" = 1;
      # Optimiser le cache
      "vm.vfs_cache_pressure" = 50;
      # Support virtualisation
      "vm.max_map_count" = 262144;
    };
  };

  # Optimisations systemd
  systemd = {
    # Timeouts courts pour services
    extraConfig = ''
      DefaultTimeoutStartSec=10s
      DefaultTimeoutStopSec=10s
    '';

    # Services non essentiels désactivés
    services = {
      # Désactiver l'attente de stabilisation udev
      systemd-udev-settle.enable = false;
      # Désactiver l'attente réseau
      NetworkManager-wait-online.enable = false;
      # Journaux en mémoire seulement
      systemd-journald.serviceConfig.MemoryLimit = "50M";
    };
  };

  # Configuration journaux système
  services.journald.extraConfig = ''
    Storage=volatile
    Compress=yes
    SystemMaxUse=50M
  '';
}
