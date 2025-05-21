#!/usr/bin/env bash
# Script de sauvegarde pour la configuration NixOS
# Configuration
BACKUP_DIR="/home/moi/Dropbox/Documents Richard/Linux/Nixos/Nixos_xfce/nixos-backups"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="nixos-config-$DATE.tar.gz"
CONFIG_DIR="/etc/nixos"
GIT_ENABLED=true
# Créer le répertoire de sauvegarde s'il n'existe pas
mkdir -p "$BACKUP_DIR"
# Si Git est activé, commit des changements actuels
if [ "$GIT_ENABLED" = true ] && [ -d "$CONFIG_DIR/.git" ]; then
  cd "$CONFIG_DIR" || exit 1
  # Vérifier s'il y a des changements non commités
  if ! git diff-index --quiet HEAD --; then
    echo "Commit des changements dans Git..."
    git add .
    git commit -m "Sauvegarde automatique - $DATE"
  fi
fi
# Créer l'archive
echo "Création de l'archive de sauvegarde..."
tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$(dirname "$CONFIG_DIR")" "$(basename "$CONFIG_DIR")"
# Supprimer les anciennes sauvegardes (garder les 10 dernières)
echo "Nettoyage des anciennes sauvegardes..."
ls -t "$BACKUP_DIR"/nixos-config-*.tar.gz | tail -n +11 | xargs -r rm
# Définir les permissions
chown -R moi: "$BACKUP_DIR"
echo "Sauvegarde terminée: $BACKUP_DIR/$BACKUP_FILE"
