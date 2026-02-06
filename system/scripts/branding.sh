#!/bin/bash
set -e

echo "Applying Hackpad OS Branding..."

# 1. Generate /usr/lib/os-release
cat <<EOF > /usr/lib/os-release
NAME="Hackpad OS"
VERSION="43"
ID=hackpad
ID_LIKE=fedora
VERSION_ID=43
PRETTY_NAME="Hackpad OS 43 (Atomic)"
ANSI_COLOR="0;34"
CPE_NAME="cpe:/o:hackpad:hackpad:43"
HOME_URL="https://github.com/m-fe02/fedora-bootc"
VARIANT="Custom BootC Image"
VARIANT_ID="bootc"
BUILD_ID=$(date +%Y%m%d)
LOGO="hackpad"
EOF

# 2. Regenerate initramfs for boot logo
KVER=$(ls /usr/lib/modules | head -n 1)
echo "Regenerating generic initramfs for kernel $KVER..."
KVER=$(ls /lib/modules | head -n 1)
dracut --force --add "systemd-cryptsetup plymouth" --kver "$KVER" /usr/lib/modules/$KVER/initramfs.img

echo "Branding complete."
