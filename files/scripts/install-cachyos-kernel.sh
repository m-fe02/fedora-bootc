#!/bin/bash
set -ex

# Install CachyOS Kernel
dnf -y remove kernel kernel-*
dnf -y copr enable bieszczaders/kernel-cachyos-lto
dnf -y install --setopt=install_weak_deps=False kernel-cachyos-lto
dnf -y copr disable bieszczaders/kernel-cachyos-lto
setsebool -P domain_kernel_load_modules on
