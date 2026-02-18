#!/bin/bash
# seal-os: Enables bootc signature enforcement for the production image

if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root."
  exit 1
fi

IMAGE_REF=$(bootc status --json | jq -r '.spec.image.image')

if [[ "$IMAGE_REF" == "null" || -z "$IMAGE_REF" ]]; then
    echo "Error: Could not determine image reference."
    exit 1
fi

echo "Enforcing signature policy for $IMAGE_REF..."

# This tells the bootloader to respect the signature requirements 
# defined in your policy.json for this specific image.
bootc switch --enforce-container-sigpolicy "$IMAGE_REF"

echo "Hackpad OS is now SEALED for production updates."
