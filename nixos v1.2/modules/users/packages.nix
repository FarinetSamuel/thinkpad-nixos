# Packages utilisateur organisés par catégorie
{ config, pkgs, pkgs-unstable, lib, ... }:

{
  users.users.moi.packages = with pkgs; [
    # === Outils système ===
    fastfetch            # Informations système stylées
    lm_sensors           # Capteurs matériels

    # === Bureautique ===
    libreoffice-fresh    # Suite bureautique complète

    # === Internet ===
    brave                # Navigateur web sécurisé
    dropbox              # Synchronisation cloud
    whatsapp-for-linux   # Messagerie WhatsApp

    # === Multimédia ===
    pkgs-unstable.gimp3  # Éditeur d'images (version 3)
    inkscape-with-extensions # dessin vectoriel

    # === Développement et IA ===
    pkgs-unstable.alpaca # Interface pour modèles LLM
    gnome-text-editor

    # === Jeux ===
    #chessx               # Jeu d'échecs

    # === Utilitaires ===
    bluez               # Outils Bluetooth
    bluez-tools         # Utilitaires Bluetooth CLI
    xarchiver		# compression et decompression

  ];
}
