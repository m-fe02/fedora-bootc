#!/usr/bin/bash
set -ex

echo "Applying security and signing policy..."

# Security & Signing Policy
cp /ctx/scripts/setup_files/policy.json /etc/containers/policy.json
cp /ctx/system/cosign.yaml /etc/containers/registries.d/cosign.yaml

# Public key for cosign validation
mkdir -p /etc/pki/containers
cp /ctx/cosign.pub /etc/pki/containers/cosign.pub

echo "Signing complete."