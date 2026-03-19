#!/usr/bin/bash
set -euo pipefail

# Cleanup artifacts that should not be part of the final container image.
# This is intended to run late in the build, just prior to linting.

echo "INFO: Running container cleanup..."

# Remove kernel artifacts from /boot (lint expects /boot empty in container images)
rm -rf /boot/* || true

# Clear runtime directories that are populated during build but should not persist
rm -rf /run/* /tmp/* || true

# Remove state directories that are typically populated at runtime/boot
# and do not have tmpfiles.d entries (which triggers bootc lint warnings)
rm -rf \
    /var/lib/containers \
    /var/lib/rpm-state \
    /var/lib/selinux/targeted/active \
    /var/lib/selinux/targeted/semanage.read.* \
    /var/lib/selinux/targeted/seusers \
    /var/lib/selinux/targeted/commit_num || true

# Recreate directories that consumers may expect to exist (empty)
mkdir -p /run /tmp /var/lib/containers /var/lib/rpm-state /var/lib/selinux/targeted
chmod 0755 /run /tmp /var/lib/containers /var/lib/rpm-state /var/lib/selinux/targeted

echo "INFO: Container cleanup complete."
