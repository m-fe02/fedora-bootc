#!/bin/bash
set -ex

# Setup External Repos
curl -s -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

# Prepare Package Lists
REMOVALS=$(grep -v '^#' /ctx/files/scripts/pkgs/remove.txt | xargs)
# Variant specific (cosmic, kde, or gnome) + optional gaming variant
GAMING=${GAMING:-false}
GAMING_SUFFIX=""
if [ "$GAMING" = "true" ]; then
    GAMING_SUFFIX="-gaming"
fi
VARIANT_INSTALLS=$(grep -v '^#' "/ctx/files/scripts/pkgs/${DESKTOP_ENV}${GAMING_SUFFIX}.txt" | xargs)

# Optionally add RPM Fusion (needed for gaming packages)
if [ "$GAMING" = "true" ]; then
    dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                   https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

# Execute Transaction
dnf upgrade -y --exclude=kernel*

# Remove first to prevent conflicts
if [ -n "$REMOVALS" ]; then
    dnf remove -y $REMOVALS
fi

# Install common and variant packages together
dnf install -y $VARIANT_INSTALLS

# Install CachyOS Kernel
bash /ctx/scripts/install-cachyos-kernel.sh

# Final Cleanup
dnf autoremove -y
dnf clean all
rm -rf /var/lib/dnf /var/log/dnf5.log
