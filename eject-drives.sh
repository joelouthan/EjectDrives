#!/bin/zsh
# Eject specific external drives by name
#
# Usage: ./eject-drives.sh
# Ejects drives listed in the DRIVES array below.
# Configure drive names before running.

DRIVES=("Media" "Archives")
FAILED=()

for drive in "${DRIVES[@]}"; do
  if sudo /usr/sbin/diskutil eject "/Volumes/$drive" 2>/dev/null; then
    echo "✓ Ejected: $drive"
  else
    FAILED+=("$drive")
    echo "✗ Failed to eject: $drive"
  fi
done

if [[ ${#FAILED[@]} -eq 0 ]]; then
  osascript -e 'display notification "Media and Archives ejected" with title "Eject Drives"'
else
  FAILED_STR=$(printf '%s, ' "${FAILED[@]}")
  osascript -e "display notification \"Failed: ${FAILED_STR%, }\" with title \"Eject Drives\""
  exit 1
fi
