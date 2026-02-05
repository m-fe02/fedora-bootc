#!/bin/bash
set -e

echo "Detecting Atomic Variant..."

VARIANTS=("cosmic-atomic" "kinoite" "silverblue")
GENERIC_ID="generic-release-identity"
GENERIC_REL="generic-release"

for VARIANT in "${VARIANTS[@]}"; do
    if rpm -q "fedora-release-identity-${VARIANT}" > /dev/null 2>&1; then
        echo "Detected ${VARIANT}. Performing Atomic Swap..."

        # 1. Perform the swap
        dnf -y install "$GENERIC_ID" "$GENERIC_REL" --allowerasing

        # 2. Check for purged assets (The 'Total 0' scenario)
        for KDIR in /usr/lib/modules/*; do
            if [ -d "$KDIR" ] && [ ! -f "$KDIR/vmlinuz" ]; then
                KVER=$(basename "$KDIR")
                echo "Critical: Boot assets missing for $KVER. Restoring..."
                
                # Reinstalling kernel-core triggers the scriptlets that:
                # - Restore vmlinuz
                # - Run dracut to build initramfs
                dnf -y install "kernel-core-$KVER"
            fi
        done

        dnf clean all
        echo "Swap complete for ${VARIANT}."
        exit 0
    fi
done

echo "No known Fedora Atomic variant detected. Skipping swap."
exit 0
