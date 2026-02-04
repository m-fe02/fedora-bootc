#!/bin/bash
set -e

# 1 Create logo file
echo "Applying Hackpad OS Branding..."

mkdir -p /usr/share/fastfetch/logos
cat <<'EOF' > /usr/share/fastfetch/logos/hackpad
                  _                    _
  /\  /\__ _  ___| | ___ __   __ _  __| |
 / /_/ / _` |/ __| |/ / '_ \ / _` |/ _` |
/ __  / (_| | (__|   <| |_) | (_| | (_| |
\/ /_/ \__,_|\___|_|\_\ .__/ \__,_|\__,_|
                      |_|
EOF

# 2. Generate /etc/os-release
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

# 3. Generate /etc/issue and /etc/issue.net
{
    cat /usr/share/fastfetch/logos/hackpad
    echo ""
    echo "This is YOUR Hackpad (\l)"
    echo "Kernel \r"
    echo ""
} > /etc/issue

# Use the same file for remote logins
cp /etc/issue /etc/issue.net

echo "Identity branding complete."
