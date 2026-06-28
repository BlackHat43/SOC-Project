#!/usr/bin/env bash

# Backup and restore validation helper for the SOC lab.
#
# Usage:
#   sudo bash scripts/backup_recovery.sh
#
# The script creates a compressed backup archive, generates a SHA-256 checksum,
# validates the checksum, and performs a safe restore test under /tmp.

set -euo pipefail

BACKUP_ROOT="/var/backups/soc-lab"
RESTORE_TEST_DIR="/tmp/soc-restore-test"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
ARCHIVE_NAME="soc_lab_backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${BACKUP_ROOT}/${ARCHIVE_NAME}"
CHECKSUM_PATH="${ARCHIVE_PATH}.sha256"

CANDIDATE_PATHS=(
  "/var/ossec/etc"
  "/etc/filebeat"
  "/etc/wazuh-dashboard"
  "/etc/wazuh-indexer"
  "/opt/soc-lab"
)

mkdir -p "${BACKUP_ROOT}"

echo "[+] Building backup file list..."
INCLUDE_PATHS=()

for path in "${CANDIDATE_PATHS[@]}"; do
  if [ -e "${path}" ]; then
    INCLUDE_PATHS+=("${path}")
    echo "    included: ${path}"
  else
    echo "    skipped:  ${path}"
  fi
done

if [ "${#INCLUDE_PATHS[@]}" -eq 0 ]; then
  echo "[!] No backup paths found. Review CANDIDATE_PATHS in the script."
  exit 1
fi

echo "[+] Creating archive: ${ARCHIVE_PATH}"
tar -czf "${ARCHIVE_PATH}" "${INCLUDE_PATHS[@]}"

echo "[+] Generating SHA-256 checksum..."
cd "${BACKUP_ROOT}"
sha256sum "${ARCHIVE_NAME}" > "${CHECKSUM_PATH}"

echo "[+] Verifying checksum..."
sha256sum -c "$(basename "${CHECKSUM_PATH}")"

echo "[+] Performing safe restore test into: ${RESTORE_TEST_DIR}"
rm -rf "${RESTORE_TEST_DIR}"
mkdir -p "${RESTORE_TEST_DIR}"
tar -xzf "${ARCHIVE_PATH}" -C "${RESTORE_TEST_DIR}"

echo "[+] Restore test file listing:"
find "${RESTORE_TEST_DIR}" -maxdepth 3 -type f | head -50

echo "[OK] Backup, checksum verification, and safe restore test completed."
echo "Archive:  ${ARCHIVE_PATH}"
echo "Checksum: ${CHECKSUM_PATH}"
