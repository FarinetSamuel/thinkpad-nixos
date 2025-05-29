# Configuration audio/vidéo

{ config, pkgs, lib, ... }:

{
  # Activation de rtkit pour les applications audio temps réel
  security.rtkit.enable = true;
  
  # Configuration PipeWire pour l'audio de haute qualité
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
