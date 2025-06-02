

# Configuration matérielle pour SSD
{ config, pkgs, lib, ... }:
{
  # Optimisations système de fichiers pour SSD (ajout aux options existantes)
  fileSystems."/".options = [ "noatime" "nodiratime" ];
  fileSystems."/boot".options = [ "noatime" "nodiratime" ];
  
  # TRIM hebdomadaire pour SSD
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
