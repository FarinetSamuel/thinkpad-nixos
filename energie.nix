{
  ######################################################################
  #        Configuration externe de la gestion des choix               #
  #         d'alimentation et des profils énergétiques                 #
  #                                                                    #
  # Ce fichier contient :                                              #
  # - Le script pour la sélection du profil d'alimentation              #
  # - Le script d'affichage de l'indicateur de batterie avec icônes      #
  # - Le script pour XFCE4 Genmon qui affiche l'état de la batterie        #
  ######################################################################

  ######################################################################
  # Script de sélection du profil d'alimentation
  ######################################################################
  environment.etc."power-profiles/power-profile-selector.sh" = {
    # Ce script permet de changer le profil d'alimentation et de créer une entrée
    # dans le menu XFCE pour sélectionner un profil parmi "eco", "balanced" et "performance".
    mode = "0755";
    text = ''
      #!/bin/sh
# Applique le profil d'alimentation choisi
set_profile() {
  case $1 in
    "eco")
      sudo cpupower frequency-set --governor powersave
      echo 'Mode économie d'"'"'énergie activé'
      ;;
    "balanced")
      sudo cpupower frequency-set --governor ondemand
      echo "Mode équilibré activé"
      ;;
    "performance")
      sudo cpupower frequency-set --governor performance
      echo "Mode performance activé"
      ;;
    *)
      echo "Profil inconnu: $1"
      exit 1
      ;;
  esac
  sudo systemctl try-reload-or-restart tlp.service
  echo "$1" > ~/.current-power-profile
}

# Affiche une interface graphique pour sélectionner le profil grâce à yad
show_gui() {
  CURRENT_PROFILE="eco"
  [ -f ~/.current-power-profile ] && CURRENT_PROFILE=$(cat ~/.current-power-profile)
  SELECTED=$(yad --center --title="Sélecteur de profil d'alimentation" \
    --text="<b>Choisissez un profil d'alimentation pour l'utilisation sur batterie:</b>\n\n" \
    --height=300 --width=450 \
    --form \
    --field="Profil:CB" \
    "eco!balanced!performance" \
    --button="Appliquer:0" \
    --button="Annuler:1")
  if [ $? -eq 0 ]; then
    PROFILE=$(echo "$SELECTED" | cut -d'|' -f1)
    set_profile "$PROFILE"
    notify-send -i battery "Profil d'alimentation" "Profil '$PROFILE' activé"
  fi
}

# Crée une entrée de menu pour XFCE dans le répertoire utilisateur
create_menu_entry() {
  mkdir -p ~/.local/share/applications/
  cat > ~/.local/share/applications/power-profile-selector.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Profils d'alimentation
Comment=Gestion des profils d'alimentation
Exec=/etc/power-profiles/power-profile-selector.sh --gui
Icon=battery
Categories=Settings;
Terminal=false
EOF
}

case "$1" in
  "--eco")
    set_profile "eco"
    ;;
  "--balanced")
    set_profile "balanced"
    ;;
  "--performance")
    set_profile "performance"
    ;;
  "--gui")
    show_gui
    ;;
  "--install")
    create_menu_entry
    echo "Menu installé dans le menu des applications"
    ;;
  *)
    echo "Usage: $0 [--eco|--balanced|--performance|--gui|--install]"
    ;;
esac
exit 0
    '';
  };

  ######################################################################
  # Script d'indication de l'état de la batterie avec affichage        #
  # d'une icône et du nom du profil (ex: "⚖️ balanced 50%")              #
  ######################################################################
  environment.etc."power-profiles/battery-indicator.sh" = {
    # Ce script combine l'icône et le texte du profil courant, ainsi que le pourcentage de batterie.
    mode = "0755";
    text = ''
      #!/bin/sh
      MAIN_SCRIPT="/etc/power-profiles/power-profile-selector.sh"

      # Fonction pour déterminer l'icône et le nom du profil.
      get_icon_and_profile() {
        CURRENT_PROFILE="eco"
        if [ -f ~/.current-power-profile ]; then
          CURRENT_PROFILE=$(cat ~/.current-power-profile)
        fi
        case "$CURRENT_PROFILE" in
          eco)
            ICON="🍃"
            ;;
          balanced)
            ICON="⚖️"
            ;;
          performance)
            ICON="🚀"
            ;;
          *)
            ICON="🔋"
            ;;
        esac
        # Combine l'icône et le texte représentant le profil
        echo "$ICON $CURRENT_PROFILE"
      }

      # Affiche l'état de la batterie en incluant : icône + texte profil + pourcentage
      get_status() {
        ICON_PROFILE=$(get_icon_and_profile)
        BAT_STATUS=$(acpi -b | cut -d',' -f1 | cut -d':' -f2 | tr -d ' ')
        BAT_PERCENT=$(acpi -b | grep -Po '[0-9]+(?=%)')
        if [ "$BAT_STATUS" = "Discharging" ]; then
          echo "$ICON_PROFILE $BAT_PERCENT%"
        else
          echo "🔌 $ICON_PROFILE $BAT_PERCENT% en charge"
        fi
      }

      # Affiche un menu de sélection de profil via yad
      show_menu() {
        cat << EOF | yad --notification --menu="Eco|$MAIN_SCRIPT --eco
Balanced|$MAIN_SCRIPT --balanced
Performance|$MAIN_SCRIPT --performance
---
Paramètres...|$MAIN_SCRIPT --gui"
EOF
      }

      case "$1" in
        "--status")
          get_status
          ;;
        "--menu")
          show_menu
          ;;
        *)
          echo "Usage: $0 [--status|--menu]"
          ;;
      esac
      exit 0
    '';
  };

  ######################################################################
  # Script pour le plugin XFCE4 Genmon affichant l'état de la batterie   #
  # et proposant d'ouvrir le menu pour changer de profil                 #
  ######################################################################
  environment.etc."power-profiles/genmon-battery.sh" = {
    # Ce script est appelé par le plugin Genmon et renvoie du XML pour :
    # - Afficher le texte (le profil et le pourcentage)
    # - Ajouter une infobulle
    # - Exécuter une action au clic (ouvrir le sélecteur de profil)
    mode = "0755";
    text = ''
      #!/bin/sh
      STATUS=$(/etc/power-profiles/battery-indicator.sh --status)
      echo "<txt>$STATUS</txt>"
      echo "<tool>Cliquez pour changer de profil d'alimentation</tool>"
      echo "<click>/etc/power-profiles/power-profile-selector.sh --gui</click>"
    '';
  };
}
