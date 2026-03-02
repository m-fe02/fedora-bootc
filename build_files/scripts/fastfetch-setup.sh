#!/bin/bash
set -e

echo "Configuring Fastfetch Presentation..."

# 1. Create the system data directory
mkdir -p /usr/share/hackpod

# 2. Create the ASCII art file
cat <<'EOF' > /usr/share/hackpod/ascii
    __  __           __   ____            __    ____  _____
   / / / /___ ______/ /__/ __ \____  ____/ /   / __ \/ ___/
  / /_/ / __ `/ ___/ //_/ /_/ / __ \/ __  /   / / / /\__ \
 / __  / /_/ / /__/ ,< / ____/ /_/ / /_/ /   / /_/ /___/ /
/_/ /_/\__,_/\___/_/|_/_/    \____/\__,_/____\____//____/
                                       /_____/
EOF

# 3. Create the Global Configuration
mkdir -p /etc/fastfetch
cat <<EOF > /etc/fastfetch/config.jsonc
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema_json",
    "logo": {
        "source": "/usr/share/hackpod/ascii",
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
