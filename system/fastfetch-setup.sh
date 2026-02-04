#!/bin/bash
set -e

echo "Configuring Fastfetch Presentation..."

# 1. Create the system data directory
mkdir -p /usr/share/hackpad

# 2. Create the ASCII art file
cat <<'EOF' > /usr/share/hackpad/ascii
                  _                    _
  /\  /\__ _  ___| | ___ __   __ _  __| |
 / /_/ / _` |/ __| |/ / '_ \ / _` |/ _` |
/ __  / (_| | (__|   <| |_) | (_| | (_| |
\/ /_/ \__,_|\___|_|\_\ .__/ \__,_|\__,_|
                      |_|
EOF

# 3. Create the Global Configuration
mkdir -p /etc/fastfetch
cat <<EOF > /etc/fastfetch/config.jsonc
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema_json",
    "logo": {
        "source": "/usr/share/hackpad/ascii",
        "type": "file",
        "padding": {
            "top": 2,
            "right": 4
        }
    },
    "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "display",
        "de",
        "wm",
        "terminal",
        "cpu",
        "gpu",
        "memory",
        "disk",
        "localip",
        "battery",
        "locale",
        "break",
        "colors"
    ]
}
EOF

echo "Fastfetch setup complete."
