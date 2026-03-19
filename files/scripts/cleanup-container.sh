#!/usr/bin/env bash
set -euo pipefail

# Cleanup artifacts that should not be part of the final container image.
# This is intended to run late in the build (before bootc container lint).

echo "INFO: Running container cleanup..."

# Clean package manager cache
if command -v dnf >/dev/null 2>&1; then
    dnf clean all || true
fi

# Remove offline kernel artifacts (lint expects /boot empty for containers)
rm -rf /boot/* /boot/.* 2>/dev/null || true

# Clear runtime directories (should be empty in container images)
rm -rf /run/* /tmp/* || true

# Remove extra state directories that typically exist only at runtime
# and are not managed by tmpfiles.d (prevents bootc lint warnings)
rm -rf \
    /var/lib/containers \
    /var/lib/rpm-state \
    /var/lib/selinux/targeted/active \
    /var/lib/selinux/targeted/semanage.read.* \
    /var/lib/selinux/targeted/seusers \
    /var/lib/selinux/targeted/commit_num || true

# Remove most /var content except log/cache
find /var/* -maxdepth 0 -type d -not -name "log" -not -name "cache" -exec rm -rvf {} + || true
find /var/cache/* -maxdepth 0 -type d -not -name "libdnf5" -not -name "rpm-ostree" -exec rm -rvf {} + || true
rm -rf /var/log/* || true

# Reset resolv.conf to avoid bind-mount artifacts
rm -f /etc/resolv.conf
touch /etc/resolv.conf

# Remove skeleton state that shouldn't be shipped
rm -rf /etc/skel/.mozilla /etc/skel/.config/user-tmpfiles.d || true

# Ensure required directories exist and are empty
mkdir -p /run /tmp /var/tmp
chmod 0755 /run /tmp
chmod 1777 /var/tmp

echo "INFO: Container cleanup complete."
