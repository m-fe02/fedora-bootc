#!/bin/bash
set -ex

BUILD_SETUP_DIR="/ctx/scripts"

echo "Step 1: Installing signing policy and public key..."
cp -drf /ctx/system/* /
mkdir -p /etc/pki/containers
cp /ctx/cosign.pub /etc/pki/containers/cosign.pub

echo "Step 2: Installing packages..."
bash "$BUILD_SETUP_DIR/01-install-pkgs.sh"

echo "Step 3: Removing unwanted desktop entries..."
bash "$BUILD_SETUP_DIR/02-remove-desktop-entries.sh"

if [ "${GAMING}" = "true" ]; then
    echo "Step 4: Installing CachyOS kernel (gaming image)..."
    bash "$BUILD_SETUP_DIR/03-install-cachyos-kernel.sh"

    echo "Step 5: Regenerating initramfs..."
    bash "$BUILD_SETUP_DIR/04-initramfs.sh"
fi

echo "Running cleanup..."
bash "$BUILD_SETUP_DIR/05-post-setup.sh"
