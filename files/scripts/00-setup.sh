#!/bin/bash
set -ex

# Fe02-OS Build Orchestrator
# Executes build steps in numbered order for clear pipeline flow

BUILD_SETUP_DIR="/ctx/scripts"

echo "=== Fe02-OS Build Pipeline ==="

echo "Step 1: Upgrading packages..."
bash "$BUILD_SETUP_DIR/01-upgrade-packages.sh"

echo "Step 5: Copying system files..."
bash "$BUILD_SETUP_DIR/04-copy-files.sh"

echo "Step 6: Installing packages..."
bash "$BUILD_SETUP_DIR/05-install-pkgs.sh"

echo "Step 7: Applying branding..."
bash "$BUILD_SETUP_DIR/06-theming.sh"

echo "Step 8: Applying tweaks and fixes..."
bash "$BUILD_SETUP_DIR/11-tweaks-and-fixes.sh"

echo "Step 9: Handling security and signing..."
bash "$BUILD_SETUP_DIR/56-signing.sh"

echo "Step 10: Regenerating initramfs..."
bash "$BUILD_SETUP_DIR/57-initramfs.sh"

echo "Step 11: Running cleanup..."
bash "$BUILD_SETUP_DIR/58-post-setup.sh"

echo "=== Build Complete ==="