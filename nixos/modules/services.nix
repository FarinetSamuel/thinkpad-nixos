# Services système

{ config, pkgs, lib, ... }:

{

  # Configuration touchpad (corrigée)
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      disableWhileTyping = true;
    };
  };

}
