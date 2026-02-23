#!/bin/bash
set -ex

# Kernel Arguments (Silent Boot)
mkdir -p /usr/lib/bootc/kargs.d/
cp /ctx/system/karg/10-silent-boot.toml /usr/lib/bootc/kargs.d/10-silent-boot.toml

# Branding & Watermark
mkdir -p /usr/share/plymouth/themes/spinner/
cp /ctx/system/branding/hackpad_transparent.png /usr/share/plymouth/themes/spinner/watermark.png

# Run the external branding/fastfetch scripts from the context
bash /ctx/scripts/branding.sh
bash /ctx/scripts/fastfetch-setup.sh

# Security & Signing Policy
cp /ctx/system/policy.json /etc/containers/policy.json
cp /ctx/system/cosign.yaml /etc/containers/registries.d/cosign.yaml

# Public key for cosign validation
mkdir -p /etc/pki/containers
cp /ctx/cosign.pub /etc/pki/containers/cosign.pub

# Persistence & Management Scripts
cp /ctx/scripts/seal-os.sh /usr/bin/seal-os
chmod +x /usr/bin/seal-os
