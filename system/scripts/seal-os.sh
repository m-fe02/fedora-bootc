#!/bin/bash
# seal-os: Hardens container policy and enables bootc signature enforcement

# Check if the script is being run as root (UID 0)
if [ "$EUID" -ne 0 ]; then 
  echo "Please run this script with sudo or as root."
  exit 1
fi

echo "Starting the Security Seal process..."

# 1. Flip the default policy
if grep -q "insecureAcceptAnything" /etc/containers/policy.json; then
    sed -i 's/insecureAcceptAnything/reject/' /etc/containers/policy.json
    echo "Global policy updated: default set to 'reject'."
else
    echo "Global policy is already set to 'reject'."
fi

# 2. Get the image reference
# We can remove 'sudo' from here too since the script is already root
IMAGE_REF=$(bootc status --json | jq -r '.spec.image.image')

if [ "$IMAGE_REF" = "null" ] || [ -z "$IMAGE_REF" ]; then
    echo "Error: Could not determine the current image reference."
    exit 1
fi

echo "Applying signature enforcement for: $IMAGE_REF"
bootc switch --enforce-container-sigpolicy "$IMAGE_REF"

echo "System is now SEALED."
