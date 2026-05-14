#!/bin/bash
set -ex

BUILD_SETUP_DIR="/ctx/scripts"

echo "Step 1: Installing signing policy and public key..."
cp -drf /ctx/system/* /
mkdir -p /etc/pki/containers
cp /ctx/cosign.pub /etc/pki/containers/cosign.pub

echo "Step 2: Upgrading packages..."
bash "$BUILD_SETUP_DIR/01-upgrade-packages.sh"

echo "Step 3: Installing packages..."
bash "$BUILD_SETUP_DIR/05-install-pkgs.sh"

echo "Step 4: Removing unwanted desktop entries..."
bash "$BUILD_SETUP_DIR/06-remove-desktop-entries.sh"

echo "Step 5: Regenerating initramfs..."
bash "$BUILD_SETUP_DIR/57-initramfs.sh"

echo "Step 6: Running cleanup..."
bash "$BUILD_SETUP_DIR/58-post-setup.sh"
