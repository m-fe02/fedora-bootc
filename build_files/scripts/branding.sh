#!/usr/bin/bash
set -eoux pipefail

echo "Configuring Fastfetch Presentation..."

# Create the system data directory
mkdir -p /usr/share/adamant

# Create the ASCII art file
cat <<EOF > /usr/share/adamant/ascii
\e[31m                                              ...                                                    
                                                 ..','',,..                                                 
                                              ..',,,,..,,,,,..                                              
                                           ..',,,,,,,..,,,,,,,'..                                           
                                        ..',,,,,,,,,,. ,,,,,,,,,,'..                                        
                                     ..',,,,,,,,,,,,,  ,,,,,,,,,,,,,,..                                     
                                  ..,,,,,,,,,,,,,,,,,  ,,,,,,,,,,,,,,,,,'.                                  
                               .',,,,,,,,,,,,,,,,,,,,  ',,,,,,,,,,,,,,,,,,,'.                               
                            ..,,,,,,,,,,,,,,,,,,,,,,,  .,,,,,,,,,,,,,,,,,,,,,,'.                            
                         ..,,,,,,,,,,,,,,,,,,,,,,,,,,  .,,,,,,,,,,,,,,,,,,,,,,,,,..                         
                        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,   ,,,,,,,,,,,,,,,,,,,,,,,,,,,,                        
                        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,.   ,,,,,,,,,,,,,,,,,,,,,,,,,,,,.                       
                        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,.   ,,,,,,,,,,,,,,,,,,,,,,,,,,,,.                       
                        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,.                       
                       .,,,,,,,,,,,,,,,,,,,,,,,,,,,,    ',,,,,,,,,,,,,,,,,,,,,,,,,,,.                       
                       .,,,,,,,,,,,,,,,,,,,,,,,,,,,,    .,,,,,,,,,,,,,,,,,,,,,,,,,,,'                       
                       .,,,,,,,,,,,,,,,,,,,,,,,,,,,,    .,,,,,,,,,,,,,,,,,,,,,,,,,,,'                       
                       .,,,,,,,,,,,,,,,,,,,,,,,,,,,      ',,,,,,,,,,,,,,,,,,,,,,,,,,,                       
                       .,,,,,,,,,,,,,,,,,,,,,,,,.           ,,,,,,,,,,,,,,,,,,,,,,,,,                       
                       ',,,,,,,,,,,,,,,,,,,,,.                 ,,,,,,,,,,,,,,,,,,,,,,                       
                       ,,,,,,,,,,,,,,,,,,,        ..',,'..        ',,,,,,,,,,,,,,,,,,.                      
                       ,,,,,,,,,,,,,,,,.      ..',,,,,,,,,,,'..      .,,,,,,,,,,,,,,,.                      
                       ,,,,,,,,,,,,,      ..',,,,,,,,,,,,,,,,,,,'..     .,,,,,,,,,,,,'                      
                      .,,,,,,,,,,.    ..',,,,,,,,,,,,,,,,,,,,,,,,,,,'..    ,,,,,,,,,,,                      
                      .,,,,,,,.  ...',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'...  ',,,,,,,                      
                      .,,,,  ''.',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'.'' .,,,,                      
                      ',.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.                     
                      .',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'.                      
                          .',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'.                          
                              .',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.                              
                                  .',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.                                  
                                      .',,,,,,,,,,,,,,,,,,,,,,,,,,,,'.                                      
                                           .',,,,,,,,,,,,,,,,,,,'.                                          
                                               .',,,,,,,,,,,.                                               
                                                   .,,,,'.                                                                                                                                                              
\e[0m
EOF

# Create the Global Configuration
mkdir -p /etc/fastfetch
cat <<EOF > /etc/fastfetch/config.jsonc
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema_json",
    "logo": {
        "source": "/usr/share/adamant/ascii",
        "type": "file",
        "padding": {
            "top": 2,
            "right": 4
        }
    },
    "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "display",
        "de",
        "wm",
        "terminal",
        "cpu",
        "gpu",
        "memory",
        "disk",
        "localip",
        "battery",
        "locale",
        "break",
        "colors"
    ]
}
EOF

echo "Fastfetch setup complete."

echo "Applying Adamant Linux Branding..."

# Identity Update
cat <<EOF > /etc/os-release
NAME="Adamant Linux"
VERSION="44"
ID=adamant
ID_LIKE=fedora
VERSION_ID=44
PRETTY_NAME="Adamant Linux (Atomic)"
ANSI_COLOR="0;34"
CPE_NAME="cpe:/o:adamant:adamant"
HOME_URL="https://github.com/m-fe02/Adamant-Linux"
VARIANT="Custom BootC Image"
VARIANT_ID="bootc"
BUILD_ID=$(date +%Y%m%d)
LOGO="adamant"
EOF

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

echo "Regenerating Initramfs..."

# Rebuild Initramfs
KERNEL_VERSION="$(rpm -q --queryformat="%{evr}.%{arch}" kernel-core)"
export DRACUT_NO_XATTR=1

# We only add 'ostree' because we trust the base image for the rest.
/usr/bin/dracut --no-hostonly \
    --kver "${KERNEL_VERSION}" \
    --reproducible \
    -v \
    --add ostree \
    -f "/lib/modules/${KERNEL_VERSION}/initramfs.img"

chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"

echo "Build script execution finished successfully."
