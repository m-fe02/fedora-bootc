#!/bin/bash
set -e

echo "Building Adamant Linux locally..."

# Build the container image with required build args
# Adjust BASE_IMAGE_NAME and DESKTOP_ENV as needed (e.g., kinoite for KDE, silverblue for GNOME)
podman build \
  --build-arg BASE_IMAGE_NAME=kinoite \
  --build-arg DESKTOP_ENV=kde \
  --build-arg GAMING=false \
  -t adamant-linux:test .

echo "Build completed successfully!"