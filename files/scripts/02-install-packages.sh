#!/bin/bash
set -ex

# Step 2: Install packages

# Setup External Repos
curl -s -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

# Prepare Package Lists
if [ -z "${DESKTOP_ENV}" ]; then
    echo "ERROR: DESKTOP_ENV is not set; must be one of: gnome, kde, cosmic" >&2
    exit 1
fi

PKG_DIR="/ctx/scripts/pkgs"
if [ ! -d "$PKG_DIR" ]; then
    echo "ERROR: package directory not found: $PKG_DIR" >&2
    exit 1
fi

REMOVALS=$(grep -v '^#' "$PKG_DIR/remove.txt" | xargs)
# Variant specific (cosmic, kde, or gnome) + optional gaming variant
GAMING=${GAMING:-false}
GAMING_SUFFIX=""
if [ "$GAMING" = "true" ]; then
    GAMING_SUFFIX="-gaming"
fi
PKG_FILE="$PKG_DIR/${DESKTOP_ENV}${GAMING_SUFFIX}.txt"
if [ ! -f "$PKG_FILE" ]; then
    echo "ERROR: package list not found: $PKG_FILE" >&2
    exit 1
fi
VARIANT_INSTALLS=$(grep -v '^#' "$PKG_FILE" | xargs)
if [ -z "$VARIANT_INSTALLS" ]; then
    echo "ERROR: package list $PKG_FILE is empty" >&2
    exit 1
fi

# Optionally add RPM Fusion (needed for gaming packages)
if [ "$GAMING" = "true" ]; then
    dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                   https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

# Remove first to prevent conflicts
if [ -n "$REMOVALS" ]; then
    dnf remove -y $REMOVALS
fi

# Install common and variant packages together
dnf install -y $VARIANT_INSTALLS

# Install CachyOS Kernel
bash /ctx/scripts/install-cachyos-kernel.sh