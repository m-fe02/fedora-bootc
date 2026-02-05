#!/bin/bash
set -e

echo "Detecting Atomic Variant..."

VARIANTS=("cosmic-atomic" "kinoite" "silverblue")
GENERIC_ID="generic-release-identity"
GENERIC_REL="generic-release"

for VARIANT in "${VARIANTS[@]}"; do
    if rpm -q "fedora-release-identity-${VARIANT}" > /dev/null 2>&1; then
        echo "Detected ${VARIANT}. Performing Atomic Swap..."

        # Swap COSMIC/Spin identity for Generic Fedora identity
        dnf -y install \
            "$GENERIC_ID" \
            "$GENERIC_REL" \
            --allowerasing

        # Explicitly install kernel packages to trigger dracut and restore vmlinuz
        # This prevents the 'Total 0' empty module directory and VFS boot panic
        echo "Re-securing kernel assets..."

	# Get the versions currently in the database to avoid 'already installed' skips
        INSTALLED_KERNELS=$(rpm -q kernel-core --queryformat '%{VERSION}-%{RELEASE}.%{ARCH} ')
	dnf -y reinstall $INSTALLED_KERNELS

        # Remove empty module directories left behind by the identity swap cleanup
        find /usr/lib/modules/ -mindepth 1 -maxdepth 1 -type d -empty -delete

        dnf clean all
        echo "Swap complete for ${VARIANT}."
        exit 0
    fi
done

echo "No known Fedora Atomic variant detected. Skipping swap."
exit 0
