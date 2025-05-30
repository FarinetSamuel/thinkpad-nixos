# Configuration matérielle spécifique ThinkPad X1 Carbon
{ config, pkgs, lib, ... }:

{
  # Support graphique Intel
  hardware.graphics = {
    enable = true;
    # Drivers pour accélération vidéo
    extraPackages = with pkgs; [
      intel-media-driver    # Driver VA-API moderne
      vaapiIntel           # Driver VA-API legacy
      vaapiVdpau           # Bridge VA-API vers VDPAU
      libvdpau-va-gl       # Backend VDPAU
    ];
    # Support 32-bit pour compatibilité
    extraPackages32 = with pkgs; [
      vaapiIntel.driver32
    ];
  };

  # Firmware et microcode
  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  # Pavé tactile optimisé
  services.libinput = {
    enable = true;
    touchpad = {
      # Configuration naturelle
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;

      # Méthodes de défilement et clic
      scrollMethod = "twofinger";
      clickMethod = "buttonareas";
      middleEmulation = true;

      # Profil d'accélération adaptatif
      accelProfile = "adaptive";
      accelSpeed = "0.3";
    };
  };

  # Optimisations système de fichiers pour SSD
  fileSystems = {
    "/" = {
      options = [ "noatime" "nodiratime" "discard" ];
    };
    "/boot" = {
      options = [ "noatime" "nodiratime" ];
    };
  };

  # TRIM hebdomadaire pour SSD
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
