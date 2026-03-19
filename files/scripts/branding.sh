#!/usr/bin/bash
set -eoux pipefail

echo "Configuring Fastfetch Presentation..."

# Create the system data directory
mkdir -p /usr/share/adamant

# Create the ASCII art file
cp ascii_art.txt /usr/share/adamant/ascii

# Copy the Fastfetch configuration
mkdir -p /etc/fastfetch
cp /ctx/system/branding/fastfetch.jsonc /etc/fastfetch/config.jsonc

echo "Fastfetch setup complete."

echo "Applying Adamant Linux Branding..."

# Identity Update
cp /ctx/system/branding/os-release /etc/os-release

# --- LOGO HIJACK SECTION START ---
echo "Applying System Logo Hijacks..."

# Plymouth Logo
mkdir -p /usr/share/plymouth/themes/spinner/
cp /ctx/system/branding/adamant.png /usr/share/plymouth/themes/spinner/watermark.png

# Distro specific logo hijacks
    PIXMAP_DIR="/usr/share/pixmaps"
    mkdir -p "$PIXMAP_DIR"

if [ -f "/ctx/system/branding/adamant.svg" ]; then
    cp /ctx/system/branding/adamant.svg "$PIXMAP_DIR/fedora_logo_med.png"
    cp /ctx/system/branding/adamant.svg "$PIXMAP_DIR/fedora_whitelogo_med.png"
    cp /ctx/system/branding/adamant.svg "$PIXMAP_DIR/system-logo-white.png"
    cp /ctx/system/branding/adamant.svg "$PIXMAP_DIR/fedora-logo-small.png"
    cp /ctx/system/branding/adamant.svg "$PIXMAP_DIR/fedora_whitelogo.svg"
    cp /ctx/system/branding/adamant.svg "$PIXMAP_DIR/fedora-logo-sprite.svg"
    cp /ctx/system/branding/adamant.svg "$PIXMAP_DIR/adamant.svg"
fi

# Raster Hijack (GDM and Legacy Fallbacks)
if [ -f "/ctx/system/branding/adamant.png" ]; then
    cp /ctx/system/branding/adamant.png "$PIXMAP_DIR/fedora-gdm-logo.png"
    # Overwriting the generic logo just in case
    cp /ctx/system/branding/adamant.png "$PIXMAP_DIR/fedora-logo.png"
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
