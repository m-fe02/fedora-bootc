#!/bin/bash
set -ex

# Adamant Linux Build Orchestrator
# Executes build steps in numbered order for clear pipeline flow

# Determine where the build context is mounted (older builds used /ctx/scripts, newer use /ctx/files/scripts)
CTX_BASE="/ctx/files"
if [ ! -d "$CTX_BASE" ]; then
    CTX_BASE="/ctx"
fi

BUILD_SETUP_DIR="$CTX_BASE/scripts"

echo "=== Adamant Linux Build Pipeline ==="

echo "Step 1: Upgrading packages..."
bash "$BUILD_SETUP_DIR/01-upgrade-packages.sh"

echo "Step 2: Installing packages and kernel..."
bash "$BUILD_SETUP_DIR/02-install-packages.sh"

echo "Step 3: Configuring system..."
bash "$BUILD_SETUP_DIR/03-configure-system.sh"

echo "Step 4: Regenerating initramfs..."
bash "$BUILD_SETUP_DIR/04-regenerate-initramfs.sh"

echo "Step 5: Final cleanup..."
bash "$BUILD_SETUP_DIR/05-cleanup.sh"

echo "=== Build Complete ==="