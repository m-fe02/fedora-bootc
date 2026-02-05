#!/bin/bash
set -e

echo "Detecting Atomic Variant..."

VARIANTS=("cosmic-atomic" "kinoite" "silverblue")
GENERIC_ID="generic-release-identity"
GENERIC_REL="generic-release"

for VARIANT in "${VARIANTS[@]}"; do
    if rpm -q "fedora-release-identity-${VARIANT}" > /dev/null 2>&1; then
        echo "Detected ${VARIANT}. Performing Atomic Swap..."
        
        # In DNF5, the most robust 'multiple swap' is an install command 
        # with --allowerasing. It treats the arrival of 'generic' 
        # as the cue to erase the 'fedora' equivalents.
        dnf -y install \
            "$GENERIC_ID" \
            "$GENERIC_REL" \
            --allowerasing
        
        dnf clean all
        echo "Swap complete for ${VARIANT}."
        exit 0
    fi
done

echo "No known Fedora Atomic variant detected. Skipping swap."
exit 0
