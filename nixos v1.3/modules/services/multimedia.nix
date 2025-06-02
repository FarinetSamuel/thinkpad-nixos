# Configuration audio et multimédia
{ config, pkgs, lib, ... }:

{
  # Support temps réel pour l'audio
  security.rtkit.enable = true;
  
  # PipeWire pour audio 
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = false;
    
    # Configuration audio basse latence 
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };
  };
  
}
