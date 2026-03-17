#!/bin/bash
set -ex

# Setup External Repos
curl -s -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

# Prepare Package Lists
REMOVALS=$(grep -v '^#' /ctx/pkgs/remove.txt | xargs)
# Variant specific (cosmic, kde, or gnome)
VARIANT_INSTALLS=$(grep -v '^#' "/ctx/pkgs/${DESKTOP_ENV}.txt" | xargs)

# Add RPM-Fusion
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
               https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Execute Transaction
dnf upgrade -y --exclude=kernel*

# Remove first to prevent conflicts
if [ -n "$REMOVALS" ]; then
    dnf remove -y $REMOVALS
fi

# Install common and variant packages together
dnf install -y $VARIANT_INSTALLS

# Install CachyOS Kernel
dnf -y remove kernel kernel-*
rm -rf /usr/lib/modules/*
dnf -y copr enable bieszczaders/kernel-cachyos-lto
dnf -y install --setopt=install_weak_deps=False kernel-cachyos-lto
dnf -y copr disable bieszczaders/kernel-cachyos-lto
setsebool -P domain_kernel_load_modules on

# Final Cleanup
dnf autoremove -y
dnf clean all
rm -rf /var/lib/dnf /var/log/dnf5.log
