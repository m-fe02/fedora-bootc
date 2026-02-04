#!/bin/bash
set -e

echo "Applying Hackpad OS Branding..."

# 1. Create the logo in a standard system data path
mkdir -p /usr/share/hackpad
cat <<'EOF' > /usr/share/hackpad/ascii
                  _                    _
  /\  /\__ _  ___| | ___ __   __ _  __| |
 / /_/ / _` |/ __| |/ / '_ \ / _` |/ _` |
/ __  / (_| | (__|   <| |_) | (_| | (_| |
\/ /_/ \__,_|\___|_|\_\ .__/ \__,_|\__,_|
                      |_|
EOF

# 2. Create the SYSTEM-WIDE Fastfetch config
# Fastfetch ALWAYS checks /etc/fastfetch/config.jsonc before its internal database
mkdir -p /etc/fastfetch
cat <<EOF > /etc/fastfetch/config.jsonc
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.jsonc",
    "logo": {
        "source": "/usr/share/hackpad/ascii",
        "type": "file"
    }
}
EOF

# 3. Generate /etc/os-release
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

# 4. Generate /etc/issue and /etc/issue.net
{
    cat /usr/share/hackpad/ascii
    echo ""
    echo "This is YOUR Hackpad (\l)"
    echo "Kernel \r"
    echo ""
} > /etc/issue

cp /etc/issue /etc/issue.net

echo "Identity branding complete. System-wide fastfetch config applied."
