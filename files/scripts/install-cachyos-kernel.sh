#!/bin/bash
set -ex

# Install CachyOS Kernel
dnf -y remove kernel kernel-*
# Set up dracut configuration for container environment
mkdir -p /etc/dracut.conf.d
cp /ctx/scripts/setup_files/dracut.conf /etc/dracut.conf.d/99-container-build.conf
# Temporarily disable rpm-ostree kernel install to prevent posttrans dracut failure
KERNEL_INSTALL_DIR="/usr/lib/kernel/install.d"
RPMOSTREE_HOOK="$KERNEL_INSTALL_DIR/05-rpmostree.install"
if [ -f "$RPMOSTREE_HOOK" ]; then
    echo "Disabling rpm-ostree kernel install hook..."
    mv "$RPMOSTREE_HOOK" "${RPMOSTREE_HOOK}.disabled"
fi
dnf -y copr enable bieszczaders/kernel-cachyos-lto
dnf -y install --setopt=install_weak_deps=False kernel-cachyos-lto
dnf -y copr disable bieszczaders/kernel-cachyos-lto
# Re-enable rpm-ostree kernel install
if [ -f "${RPMOSTREE_HOOK}.disabled" ]; then
    echo "Re-enabling rpm-ostree kernel install hook..."
    mv "${RPMOSTREE_HOOK}.disabled" "$RPMOSTREE_HOOK"
fi
depmod -a
setsebool -P domain_kernel_load_modules on
