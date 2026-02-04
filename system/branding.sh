#!/bin/bash
set -e

echo "Applying Hackpad OS Branding..."

# 1. Generate /usr/lib/os-release
# This is the core identity file that COSMIC and other system tools read.
cat <<EOF > /usr/lib/os-release
NAME="Hackpad OS"
VERSION="43"
ID=hackpad
ID_LIKE=fedora
VERSION_ID=43
PRETTY_NAME="Hackpad OS 43 (Atomic)"
ANSI_COLOR="0;34"
CPE_NAME="cpe:/o:hackpad:hackpad:43"
HOME_URL="https://github.com/m-fe02/fedora-bootc"
VARIANT="Custom BootC Image"
VARIANT_ID="bootc"
BUILD_ID=$(date +%Y%m%d)
LOGO="hackpad"
EOF

echo "Identity branding complete."
