#!/bin/bash
set -ex

# Kernel Arguments (Silent Boot)
mkdir -p /usr/lib/bootc/kargs.d/
cp /ctx/files/system/karg/10-silent-boot.toml /usr/lib/bootc/kargs.d/10-silent-boot.toml

# Run the external branding/regenerate-initramfs scripts from the context
bash /ctx/scripts/branding.sh
bash /ctx/scripts/regenerate-initramfs.sh

# Security & Signing Policy
cp /ctx/files/scripts/setup_files/policy.json /etc/containers/policy.json
cp /ctx/files/system/cosign.yaml /etc/containers/registries.d/cosign.yaml

# Public key for cosign validation
mkdir -p /etc/pki/containers
cp /ctx/cosign.pub /etc/pki/containers/cosign.pub

# Persistence & Management Scripts
cp /ctx/files/bin/seal-os.sh /usr/bin/seal-os
cp /ctx/files/bin/als /usr/bin/als
chmod +x /usr/bin/seal-os
chmod +x /usr/bin/als

# Final cleanup to keep the resulting container image clean
bash /ctx/scripts/cleanup-container.sh
