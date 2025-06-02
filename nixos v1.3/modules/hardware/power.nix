# Gestion d'énergie et performances
{ config, pkgs, lib, ... }:

{
  # TLP pour gestion d'énergie avancée
  services.tlp = {
    enable = true;
    settings = {
      # Sur secteur : performances maximales
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;

      # Sur batterie : équilibré
      CPU_SCALING_GOVERNOR_ON_BAT = "balanced";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      # Seuils de charge batterie (prolonge la durée de vie)
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 89;

      # Optimisations additionnelles
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
    };
  };

  # ZRAM pour swap compressé en mémoire
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # Services d'alimentation
  services = {
    # Service de gestion d'alimentation
    upower.enable = true;

    # Mise en veille automatique
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "ignore";
    };
  };
}
