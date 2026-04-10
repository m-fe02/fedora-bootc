#!/usr/bin/bash
set -eoux pipefail

echo "Configuring Fastfetch Presentation..."

# Create the system data directory
mkdir -p /usr/share/fe02

# Create the ASCII art file
cp /ctx/system/branding/ascii_art.txt /usr/share/fe02/ascii

# Copy the Fastfetch configuration
mkdir -p /etc/fastfetch
cp /ctx/system/branding/fastfetch.jsonc /etc/fastfetch/config.jsonc

echo "Fastfetch setup complete."

echo "Applying Fe02-OS Branding..."

# Identity Update
cp /ctx/system/branding/os-release /etc/os-release

# --- LOGO HIJACK SECTION START ---
echo "Applying System Logo Hijacks..."

# Plymouth Logo
mkdir -p /usr/share/plymouth/themes/spinner/
cp /ctx/system/branding/crocus_martis_white.svg /usr/share/plymouth/themes/spinner/watermark.png

# Distro specific logo hijacks
    PIXMAP_DIR="/usr/share/pixmaps"
    mkdir -p "$PIXMAP_DIR"

if [ -f "/ctx/system/branding/crocus_martis.svg" ]; then
    cp /ctx/system/branding/crocus_martis.svg "$PIXMAP_DIR/fedora_logo_med.png"
    cp /ctx/system/branding/crocus_martis_white.svg "$PIXMAP_DIR/fedora_whitelogo_med.png"
    cp /ctx/system/branding/crocus_martis_white.svg "$PIXMAP_DIR/system-logo-white.png"
    cp /ctx/system/branding/crocus_martis.svg "$PIXMAP_DIR/fedora-logo-small.png"
    cp /ctx/system/branding/crocus_martis_white.svg "$PIXMAP_DIR/fedora_whitelogo.svg"
    cp /ctx/system/branding/crocus_martis.svg "$PIXMAP_DIR/fedora-logo-sprite.svg"
    cp /ctx/system/branding/crocus_martis.svg "$PIXMAP_DIR/crocus_martis.svg"
fi

# Raster Hijack (GDM and Legacy Fallbacks)
if [ -f "/ctx/system/branding/crocus_martis_white.svg" ]; then
    cp /ctx/system/branding/crocus_martis_white.svg "$PIXMAP_DIR/fedora-gdm-logo.png"
    # Overwriting the generic logo just in case
    cp /ctx/system/branding/crocus_martis_white.svg "$PIXMAP_DIR/fedora-logo.png"
fi
# --- HIJACK SECTION END ---

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
