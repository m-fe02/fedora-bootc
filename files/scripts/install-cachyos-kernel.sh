#!/bin/bash
set -ex

# Ensure dracut includes syslog support (needed inside container builds)
# Some dracut wrappers used by rpm-ostree may ignore /etc/dracut.conf.d,
# so we set the core config file as well.
mkdir -p /etc/dracut.conf.d
cat > /etc/dracut.conf.d/99-syslog.conf <<'EOF'
# Ensure syslog/logger support is present in initramfs builds.
# This prevents dracut failures when kernel-install runs inside a container.
add_dracutmodules+=" syslog "
EOF

cat > /etc/dracut.conf <<'EOF'
# Ensure syslog/logger support is present in initramfs builds.
# This is a fallback in case dracut ignores /etc/dracut.conf.d.
add_dracutmodules+=" syslog "
EOF

# If rpm-ostree provides a wrapped dracut, make sure it's used for kernel-install.
# (rpm-ostree/sandboxing can otherwise cause "permission denied" failures.)
if [[ -x "/usr/libexec/rpm-ostree/wrapped/dracut" ]]; then
    ln -sf /usr/libexec/rpm-ostree/wrapped/dracut /usr/bin/dracut
fi

# Install CachyOS Kernel
dnf -y remove kernel kernel-*
rm -rf /usr/lib/modules/*
dnf -y copr enable bieszczaders/kernel-cachyos-lto
dnf -y install --setopt=install_weak_deps=False kernel-cachyos-lto
dnf -y copr disable bieszczaders/kernel-cachyos-lto
setsebool -P domain_kernel_load_modules on
