#!/bin/bash
set -ex

# Step 5: Install packages

# Setup External Repos
curl -s -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

# Validate input
if [ -z "${DESKTOP_ENV}" ]; then
    echo "ERROR: DESKTOP_ENV is not set; must be one of: gnome, kde, cosmic" >&2
    exit 1
fi

PKG_DIR="/ctx/scripts/pkgs"
if [ ! -d "$PKG_DIR" ]; then
    echo "ERROR: package directory not found: $PKG_DIR" >&2
    exit 1
fi

PKG_FILE="$PKG_DIR/packages.yaml"
if [ ! -f "$PKG_FILE" ]; then
    echo "ERROR: package list not found: $PKG_FILE" >&2
    exit 1
fi

DNF_INSTALL=(dnf --setopt=install_weak_deps=False install -y)

# Install yq if not present (for YAML parsing)
if ! command -v yq &> /dev/null; then
    echo "Installing yq for YAML parsing..."
    "${DNF_INSTALL[@]}" yq
fi

# Parse packages from YAML
echo "Parsing packages for variant: $DESKTOP_ENV"

# Get packages to remove
REMOVALS=$(yq -r '.packages.remove[]' "$PKG_FILE" | xargs)

# Get base packages for the variant
BASE_PKGS=$(yq -r ".packages.variants.${DESKTOP_ENV}.base[]" "$PKG_FILE" | xargs)
if [ -z "$BASE_PKGS" ]; then
    echo "ERROR: No base packages found for variant: $DESKTOP_ENV" >&2
    exit 1
fi

# Get gaming packages if enabled
GAMING=${GAMING:-false}
GAMING_PKGS=""
if [ "$GAMING" = "true" ]; then
    echo "Gaming enabled; including gaming packages..."
    GAMING_PKGS=$(yq -r ".packages.variants.${DESKTOP_ENV}.gaming[]" "$PKG_FILE" | xargs)
    
    # Install RPM Fusion for gaming packages
    "${DNF_INSTALL[@]}" https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                   https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

# Combine base and gaming packages
VARIANT_INSTALLS="$BASE_PKGS $GAMING_PKGS"

# Remove first to prevent conflicts
if [ -n "$REMOVALS" ]; then
    echo "Removing bloat packages..."
    dnf remove -y $REMOVALS || true
fi

# Install common and variant packages together
echo "Installing variant packages..."
"${DNF_INSTALL[@]}" $VARIANT_INSTALLS

# Install CachyOS Kernel
bash /ctx/scripts/install-cachyos-kernel.sh