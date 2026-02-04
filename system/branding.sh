#!/bin/bash
set -e

echo "Applying Hackpad OS Branding..."

ASCII_ART='
                  _                     _
  /\  /\__ _  ___| | ___ __   __ _  __| |
 / /_/ / _` |/ __| |/ / '_ \ / _` |/ _` |
/ __  / (_| | (__|   <| |_) | (_| | (_| |
\/ /_/ \__,_|\___|_|\_\ .__/ \__,_|\__,_|
                      |_|'

echo "$ASCII_ART" > /etc/logo.txt

# 1. Generate /etc/os-release
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
VARIANT="Developer"
BUILD_ID=$(date +%Y%m%d)
LOGO="/etc/logo.txt"
EOF

# 2. Generate /etc/issue and /etc/issue.net
cat <<'EOF' > /etc/issue
$ASCII_ART

This is YOUR Hackpad (\l)
Kernel \r
EOF

# Use the same file for remote logins
cp /etc/issue /etc/issue.net

echo "Identity branding complete."
