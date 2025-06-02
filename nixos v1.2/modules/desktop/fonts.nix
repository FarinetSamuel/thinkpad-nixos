# Configuration des polices système
{ config, pkgs, lib, ... }:

{
  fonts = {
    # Activer les paquets de polices par défaut
    enableDefaultPackages = true;

    # Sélection de polices
    packages = with pkgs; [
      # Polices Nerd avec icônes
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono

      # Polices système essentielles
      cantarell-fonts
      liberation_ttf

      # Polices internationales
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      # Polices modernes
      inter
      roboto
      fira-code
    ];

    # Configuration par défaut
    fontconfig = {
      # Cache 32-bit pour compatibilité
      cache32Bit = true;

      # Polices par défaut
      defaultFonts = {
        sansSerif = [ "Inter" "Roboto" "DejaVu Sans" ];
        serif = [ "DejaVu Serif" "Liberation Serif" ];
        monospace = [ "JetBrains Mono" "Fira Code" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
