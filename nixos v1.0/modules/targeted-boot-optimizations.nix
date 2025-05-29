# Optimisations ciblées basées sur l'analyse systemd-analyze

{ config, lib, pkgs, ... }:

{
  # 1. Optimisation du pare-feu (le service le plus lent à 1.812s)
  networking.firewall = {
    # Utiliser nftables au lieu d'iptables (plus rapide)
    enable = true;
    package = pkgs.nftables;
    
    # Charger le pare-feu en background pour ne pas bloquer le démarrage
    # Cela peut réduire le temps de démarrage visible de ~1.8s
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.nftables}/bin/nft -f /etc/nftables.conf";
    };
    
  # 2. Optimisation de Plymouth (1.072s)
  boot.plymouth = {
    enable = true;
    # Thème minimaliste qui charge plus rapidement
    theme = "spinner";
    # Désactiver les animations complexes
    themePackages = lib.mkForce [ pkgs.plymouth ];
  };
  
  # Désactiver les écritures inutiles pendant le démarrage
  # (pour remplacer plymouth-read-write.service)
  systemd.services.plymouth-read-write = {
    serviceConfig = {
      ExecStart = lib.mkForce "${pkgs.coreutils}/bin/true";
      Type = "oneshot";
    };
  };

  # 3. Optimisation de NetworkManager (881ms)
  networking.networkmanager = {
    enable = true;
    # Démarrer le service en arrière-plan pour ne pas bloquer le boot
    serviceConfig = {
      ExecStart = [ "" "${pkgs.networkmanager}/bin/NetworkManager --no-daemon" ];
    };
    # Désactiver des plugins non-essentiels
    plugins = lib.mkForce [];
    # Réduire les logs et la verbosité
    extraConfig = ''
      [logging]
      level=WARN
      
      [main]
      dhcp=internal
      no-auto-default=*
    '';
  };
  
  # Désactiver complètement l'attente du réseau
  systemd.services.NetworkManager-wait-online.enable = false;
  
  # 4. Optimisation du chargement des modules (466ms)
  # Réduction des modules chargés au démarrage
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce [ 
    # Modules essentiels uniquement
    "xhci_pci" "nvme" "usb_storage" "sd_mod"
    # Module graphique Intel pour votre ThinkPad
    "i915"
  ];
  
  # 5. Optimisation TLP (431ms)
  services.tlp = {
    enable = true;
    # Démarrer TLP en arrière-plan
    serviceConfig = {
      Type = "forking";
    };
    # Configuration simplifiée
    settings = {
      # Paramètres minimalistes pour un démarrage plus rapide
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;
    };
  };
  
  # 6. Optimisation du chargement des montages (386ms pour boot.mount)
  fileSystems = {
    "/" = lib.mkIf (config.fileSystems ? "/") {
      options = [ "noatime" "nodiratime" "discard" ];
    };
    "/boot" = lib.mkIf (config.fileSystems ? "/boot") {
      options = [ "noatime" "nodiratime" ];
    };
  };
  
  # 8. Optimisation DBus (336ms)
  services.dbus = {
    implementation = "broker"; # Utiliser dbus-broker, plus rapide que dbus-daemon
  };
  
  # 9. Optimisation du gestionnaire d'affichage (252ms)
  services.xserver.displayManager = {
    lightdm = {
      # Configuration allégée de LightDM
      background = lib.mkForce "#000000";
      extraConfig = ''
        # Désactiver l'animation de démarrage
        #xserver-allow-tcp=false
        #xserver-layout=default
        #xserver-command=X -core
        # Utiliser un thème minimal
        greeter-hide-users=true
        greeter-show-manual-login=true
      '';
    };
  };
  
  # 10. Optimisation des services restants
  systemd.services = {
    # Accélérer logrotate (234ms)
    logrotate = {
      serviceConfig = {
        Type = "oneshot";
        Nice = 19; # Priorité basse
        IOSchedulingClass = "idle";
      };
    };
    
    # Accélérer UPower (233ms)
    upower = {
      serviceConfig = {
        Nice = 10;
      };
    };
    
    # Accélérer accounts-daemon (227ms)
    accounts-daemon = {
      serviceConfig = {
        Type = "simple";
      };
    };
  };
  
  # Optimisation globale systemd
  systemd = {
    # Réduire le timeout des services pour un démarrage plus rapide
    extraConfig = ''
      DefaultTimeoutStartSec=5s
      DefaultTimeoutStopSec=5s
    '';
    
    # Démarrage parallèle plus agressif
    services = {
      # Utiliser moins de ressources pour journald
      systemd-journald = {
        serviceConfig = {
          Nice = 5;
          IOSchedulingClass = "idle";
          MemoryLimit = "50M";
        };
      };
    };
  };
  
  # Optimisations globales additionnelles
  boot = {
    # Paramètres kernel pour démarrage rapide
    kernelParams = [
      "quiet" 
      "splash"
      "loglevel=0"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"
      "fastboot"
      "i915.fastboot=1"
    ];
    
    # Réduire le délai d'attente du GRUB
    loader.timeout = 0;
    
    # Accélérer les processus d'initialisation
    initrd.compressor = "zstd";
    initrd.compressorArgs = [ "-19" "-T0" ];
  };
}
