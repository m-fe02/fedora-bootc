#!/usr/bin/bash
set -eoux pipefail

echo "Configuring Fastfetch Presentation..."

# Create the system data directory
mkdir -p /usr/share/hackpod

# Create the ASCII art file
cat <<'EOF' > /usr/share/hackpod/ascii
    __  __           __   ____            __    ____  _____
   / / / /___ ______/ /__/ __ \____  ____/ /   / __ \/ ___/
  / /_/ / __ `/ ___/ //_/ /_/ / __ \/ __  /   / / / /\__ \
 / __  / /_/ / /__/ ,< / ____/ /_/ / /_/ /   / /_/ /___/ /
/_/ /_/\__,_/\___/_/|_/_/    \____/\__,_/____\____//____/
                                       /_____/
EOF

# Create the Global Configuration
mkdir -p /etc/fastfetch
cat <<EOF > /etc/fastfetch/config.jsonc
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema_json",
    "logo": {
        "source": "/usr/share/hackpod/ascii",
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

echo "Applying HackPod_OS Branding..."

# Identity Update
cat <<EOF > /etc/os-release
NAME="HackPod_OS"
VERSION="43"
ID=hackpod
ID_LIKE=fedora
VERSION_ID=43
PRETTY_NAME="HackPod_OS (Atomic)"
ANSI_COLOR="0;34"
CPE_NAME="cpe:/o:hackpod:hackpod"
HOME_URL="https://github.com/m-fe02/hackpadOS"
VARIANT="Custom BootC Image"
VARIANT_ID="bootc"
BUILD_ID=$(date +%Y%m%d)
LOGO="hackpod"
EOF

# --- LOGO HIJACK SECTION START ---
echo "Applying System Logo Hijacks..."

# Plymouth Logo
mkdir -p /usr/share/plymouth/themes/spinner/
cp /ctx/system/branding/hackpod_OS_transparent.png /usr/share/plymouth/themes/spinner/watermark.png

# Gnome specific logo hijacks
if [[ "${DESKTOP_ENV:-}" == *"gnome"* ]]; then
    echo "GNOME environment detected. Overwriting GDM branding..."
    mkdir -p /usr/share/pixmaps
    
    # Hijack the GDM login logo
    if [ -f "/ctx/system/branding/hackpod_OS_transparent.png" ]; then
        cp /ctx/system/branding/hackpod_OS_transparent.png /usr/share/pixmaps/fedora-gdm-logo.png
    fi

    # Provide the standard logo for the 'About' page
    if [ -f "/ctx/system/branding/hackpod_OS_transparent.svg" ]; then
        cp /ctx/system/branding/hackpod_OS_transparent.svg /usr/share/pixmaps/fedora_logo_med.png
    fi
else
    echo "Non-GNOME environment (${DESKTOP_ENV:-}) detected. Skipping GDM hijacks."
fi
# --- HIJACK SECTION END ---

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
