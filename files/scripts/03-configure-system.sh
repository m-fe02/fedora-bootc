#!/bin/bash
set -ex

# Step 3: Configure system

# Kernel Arguments (Silent Boot)
mkdir -p /usr/lib/bootc/kargs.d/
cp /ctx/files/system/karg/10-silent-boot.toml /usr/lib/bootc/kargs.d/10-silent-boot.toml

# Run branding
bash /ctx/scripts/branding.sh

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