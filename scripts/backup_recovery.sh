#!/bin/bash
# Disaster Recovery Script
# Target: Monitoring and restoring critical_config.txt

BACKUP_DIR="/home/kali/Desktop/Final/backups"
SOURCE_DIR="/home/kali/Desktop/Final/monitored"
RESTORE_DIR="/tmp/soc-restore-test"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"
mkdir -p "$RESTORE_DIR"

# Backup and compress
tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" -C "$SOURCE_DIR" .

# Generate SHA-256 Checksum for integrity validation
sha256sum "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" > "$BACKUP_DIR/backup_$TIMESTAMP.sha256"

# Simulation of Recovery
tar -xzf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" -C "$RESTORE_DIR"
sha256sum -c "$BACKUP_DIR/backup_$TIMESTAMP.sha256"