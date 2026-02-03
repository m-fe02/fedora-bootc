#!/bin/bash
set -e

echo "Detecting Atomic Variant..."

# Define the possible identity packages
VARIANTS=("cosmic-atomic" "kinoite" "silverblue")
GENERIC_ID="generic-release-identity"
GENERIC_REL="generic-release"

for VARIANT in "${VARIANTS[@]}"; do
    if rpm -q "fedora-release-identity-${VARIANT}" > /dev/null 2>&1; then
        echo "Detected ${VARIANT}. Performing Atomic Swap..."
        
        dnf swap -y \
            "fedora-release-identity-${VARIANT}" "$GENERIC_ID" \
            "fedora-release-${VARIANT}" "$GENERIC_REL" \
            --allowerasing
        
        dnf clean all
        echo "Swap complete for ${VARIANT}."
        exit 0
    fi
done

echo "No known Fedora Atomic variant detected. Skipping swap."
exit 0
