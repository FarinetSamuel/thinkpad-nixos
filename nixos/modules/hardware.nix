# Configuration matérielle et optimisations

{ config, pkgs, lib, ... }:

{

  
  # Configuration du noyau
  boot = {
    # Plymouth pour un écran de démarrage plus agréable
    plymouth = {
      enable = true;
      theme = "spinner";
    };

    # Dernière version du noyau Linux pour les meilleures performances
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Modules noyau nécessaires pour le ThinkPad
    kernelModules = [ "kvm-intel" ];
    
    # Configuration de modules pour les optimisations
    extraModprobeConfig = ''
      # Virtualisation imbriquée pour KVM
      options kvm_intel nested=1
      
      # Économie d'énergie pour le module Wi-Fi Intel
      options iwlwifi power_save=1
    '';
    
    # Paramètres du noyau pour l'efficacité énergétique
    kernelParams = [
      # Mode passif pour intel_pstate
      "intel_pstate=passive"
    ];
    
    # Configuration du chargeur de démarrage
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # Réduction du temps d'attente pour un démarrage plus rapide
      timeout = 1;
    };
  };

  # Configuration graphique Intel
  hardware.graphics = {
    enable = true;
    # Paquets pour l'accélération vidéo 
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs; [ vaapiIntel.driver32 ];
  };

  # Configuration TLP pour gestion avancée de l'énergie
  services.tlp = {
    enable = true;
    settings = {
      # Configuration pour le branchement sur secteur
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;

      # Configuration pour le fonctionnement sur batterie
      CPU_SCALING_GOVERNOR_ON_BAT = "balanced";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Limites de charge de la batterie pour prolonger sa durée de vie
      START_CHARGE_THRESH_BAT0 = 85;  # Commencer à charger à 85%
      STOP_CHARGE_THRESH_BAT0 = 89;   # Arrêter de charger à 89%
    };
  };

  # Utilisation de zram pour le swap
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # Algorithme de compression efficace
    memoryPercent = 100;  # Utilisation de 75% de la RAM pour zram
  };

  # Trim périodique pour les SSD
  services.fstrim.enable = true;
  
  # Optimisation des journaux système
  services.journald.extraConfig = ''
    # Stockage volatile pour éviter l'usure du SSD
    Storage=volatile
    # Compression des journaux
    Compress=yes
    # Limitation de l'utilisation mémoire
    SystemMaxUse=50M
  '';
}
