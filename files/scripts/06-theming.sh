#!/usr/bin/bash
set -ex

echo "Applying Fe02-OS Branding..."

# Create the system data directory
mkdir -p /usr/share/fe02

# Create the ASCII art file
cp /usr/share/fastfetch/presets/fe02/fe02-ascii.txt /usr/share/fe02/ascii

# Copy the Fastfetch configuration
mkdir -p /etc/fastfetch
cp /usr/share/fastfetch/presets/fe02/fe02-fastfetch.jsonc /etc/fastfetch/config.jsonc

echo "Fastfetch setup complete."

# Set Plymouth theme
plymouth-set-default-theme spinner

echo "Plymouth theme set."

echo "Purging unwanted desktop entries..."

FORBIDDEN_APP_ENTRIES=(
    "org.freedesktop.MalcontentControl.desktop"
)

for entry in "${FORBIDDEN_APP_ENTRIES[@]}"; do
    TARGET="/usr/share/applications/$entry"
    if [ -f "$TARGET" ]; then
        echo "Removing: $entry"
        rm -f "$TARGET"
    fi
done

echo "Build script execution finished successfully."
