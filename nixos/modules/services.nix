# Services système

{ config, pkgs, lib, ... }:

{
  # Configuration du service n8n
  services.n8n = {
    enable = true;
    openFirewall = true;
    settings = {
      port = 5678;
    };
  };
  
  # Autres services peuvent être ajoutés ici
  # ...
}
