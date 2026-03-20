#!/bin/bash
set -ex

# Install CachyOS Kernel
dnf -y remove kernel kernel-*
rm -rf /usr/lib/modules/*
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
# Run depmod for installed kernels
for kernel_dir in /usr/lib/modules/*/; do
    if [ -d "$kernel_dir" ]; then
        kernel_ver=$(basename "$kernel_dir")
        depmod "$kernel_ver" 2>/dev/null || echo "depmod warning for $kernel_ver (expected)"
    fi
done
# Re-enable rpm-ostree kernel install
if [ -f "${RPMOSTREE_HOOK}.disabled" ]; then
    echo "Re-enabling rpm-ostree kernel install hook..."
    mv "${RPMOSTREE_HOOK}.disabled" "$RPMOSTREE_HOOK"
fi
setsebool -P domain_kernel_load_modules on
