#!/bin/bash
set -ex

echo "INFO: Running container cleanup..."

dnf clean all
rm -rf /var/lib/dnf /var/log/dnf5.log /var/cache/libdnf5

rm -rf /boot/* /boot/.* 2>/dev/null || true

find /var/log -type f -delete
mkdir -p /var/log/journal
chmod 2755 /var/log/journal
chown root:systemd-journal /var/log/journal

rm -rf \
    /var/lib/containers \
    /var/lib/rpm-state \
    /var/lib/selinux/targeted/active \
    /var/lib/selinux/targeted/semanage.read.* \
    /var/lib/selinux/targeted/seusers \
    /var/lib/selinux/targeted/commit_num || true

rm -rf /run/* /tmp/* /var/tmp/* || true

mkdir -p /run /tmp /var/tmp
chmod 0755 /run /tmp
chmod 1777 /var/tmp

rm -f /etc/resolv.conf
touch /etc/resolv.conf
rm -rf /etc/skel/.mozilla /etc/skel/.config/user-tmpfiles.d || true

# Post-install logic for Ollama
if command -v ollama &> /dev/null; then
    echo "INFO: Ollama detected, configuring user and state directory..."
    getent group ollama >/dev/null || groupadd -r ollama
    getent passwd ollama >/dev/null || useradd -r -g ollama -d /var/lib/ollama -s /sbin/nologin ollama
    mkdir -p /var/lib/ollama
    chown -R ollama:ollama /var/lib/ollama
    chmod 0750 /var/lib/ollama
    if [ -x /sbin/restorecon ]; then
        restorecon -R /var/lib/ollama || true
    fi
fi

systemd-tmpfiles --create --boot --root=/ || true

echo "INFO: Container cleanup complete."
