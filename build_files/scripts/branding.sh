#!/usr/bin/bash
set -eoux pipefail

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
HOME_URL="https://github.com/m-fe02/fedora-bootc"
VARIANT="Custom BootC Image"
VARIANT_ID="bootc"
BUILD_ID=$(date +%Y%m%d)
LOGO="hackpod"
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
