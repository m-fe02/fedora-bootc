#!/usr/bin/bash
set -eoux pipefail

echo "Applying Hackpad OS Branding..."

# Identity Update
cat <<EOF > /etc/os-release
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
