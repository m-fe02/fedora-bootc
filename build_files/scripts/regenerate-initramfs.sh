#!/usr/bin/bash
set -eoux pipefail

echo "Regenerating Initramfs..."

KERNEL_PATHS=($(find /usr/lib/modules -mindepth 1 -maxdepth 1 -type d -exec test -e "{}/initramfs.img" \; -print))

if [ "${#KERNEL_PATHS[@]}" -ne 1 ]; then
    echo "Error: Found ${#KERNEL_PATHS[@]} kernels with initramfs.img, expected 1." >&2
    exit 1
fi

KERNEL_PATH="${KERNEL_PATHS[0]}"
KERNEL_VERSION="$(basename "${KERNEL_PATH}")"

# Rebuild Initramfs
export DRACUT_NO_XATTR=1

# We only add 'ostree' because we trust the base image for the rest.
/usr/bin/dracut --no-hostonly \
    --kver "${KERNEL_VERSION}" \
    --reproducible \
    -v \
    --add ostree \
    -f "/lib/modules/${KERNEL_VERSION}/initramfs.img"

chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"

echo "Initramfs regeneration finished successfully."