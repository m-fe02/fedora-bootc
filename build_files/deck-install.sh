#!/bin/bash
set -ex

# Add Tailscale repo
if [ ! -f /etc/yum.repos.d/tailscale.repo ]; then
    curl -s -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
fi

# Install packages
VARIANT_INSTALLS=$(grep -v '^#' "/ctx/pkgs/${DESKTOP_ENV}.txt" | xargs)

if [ -n "$VARIANT_INSTALLS" ]; then
    dnf install -y $VARIANT_INSTALLS
fi

# Cleanup
dnf clean all
rm -rf /var/lib/dnf /var/log/dnf5.log
