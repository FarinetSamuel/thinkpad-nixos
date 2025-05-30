#!/usr/bin/env bash
# Script de sauvegarde automatique pour configuration NixOS
# Maintient des sauvegardes versionnées et un dépôt Git

# === Configuration ===
BACKUP_DIR="/home/moi/Dropbox/Documents_Richard/Linux/Nixos/Nixos_xfce/nixos-backups"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="nixos-config-$DATE.tar.gz"
CONFIG_DIR="/etc/nixos"
GIT_ENABLED=true
KEEP_BACKUPS=10

# === Fonctions ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# === Script principal ===
log "Début de la sauvegarde NixOS"

# Créer le répertoire de sauvegarde
mkdir -p "$BACKUP_DIR"

# Gestion Git si activé
if [ "$GIT_ENABLED" = true ] && [ -d "$CONFIG_DIR/.git" ]; then
    cd "$CONFIG_DIR" || exit 1

    # Vérifier les changements
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        log "Commit des changements dans Git..."
        git add .
        git commit -m "Sauvegarde automatique - $DATE" || log "Pas de changements à commiter"
    else
        log "Pas de changements Git détectés"
    fi
fi

# Créer l'archive
log "Création de l'archive: $BACKUP_FILE"
tar -czf "$BACKUP_DIR/$BACKUP_FILE" \
    -C "$(dirname "$CONFIG_DIR")" \
    "$(basename "$CONFIG_DIR")" \
    --exclude=".git/objects" \
    --exclude="result"

# Nettoyage des anciennes sauvegardes
log "Nettoyage des anciennes sauvegardes (garde les $KEEP_BACKUPS dernières)"
find "$BACKUP_DIR" -name "nixos-config-*.tar.gz" -type f -printf "%T@ %p\n" | \
    sort -rn | \
    awk "NR>$KEEP_BACKUPS {print \$2}" | \
    xargs -r rm

# Permissions
chown -R moi:users "$BACKUP_DIR"

log "Sauvegarde terminée: $BACKUP_DIR/$BACKUP_FILE"
