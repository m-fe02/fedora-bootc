#!/bin/bash
set -ex

# Install CachyOS Kernel
dnf -y remove kernel kernel-*
# Temporarily disable rpm-ostree kernel install to prevent posttrans dracut failure
if [ -f /usr/lib/kernel/install.d/05-rpmostree.install ]; then
    mv /usr/lib/kernel/install.d/05-rpmostree.install /usr/lib/kernel/install.d/05-rpmostree.install.disabled
fi
dnf -y copr enable bieszczaders/kernel-cachyos-lto
dnf -y install --setopt=install_weak_deps=False kernel-cachyos-lto
dnf -y copr disable bieszczaders/kernel-cachyos-lto
# Re-enable rpm-ostree kernel install
if [ -f /usr/lib/kernel/install.d/05-rpmostree.install.disabled ]; then
    mv /usr/lib/kernel/install.d/05-rpmostree.install.disabled /usr/lib/kernel/install.d/05-rpmostree.install
fi
depmod -a
setsebool -P domain_kernel_load_modules on
