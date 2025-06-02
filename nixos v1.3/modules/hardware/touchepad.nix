# Environnement XFCE

{ config, pkgs, lib, ... }:

{

  # Configuration touchpad pour ThinkPad
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      middleEmulation = true;
      scrollMethod = "twofinger";
      clickMethod = "buttonareas";
      accelProfile = "adaptive";
      accelSpeed = "0.3";
    };
    mouse = {
      accelProfile = "flat";
      middleEmulation = false;
    };
  };

}
