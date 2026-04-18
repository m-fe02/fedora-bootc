#!/usr/bin/bash
set -ex

echo "Applying system tweaks and fixes..."

# Kernel Arguments (Silent Boot)
mkdir -p /usr/lib/bootc/kargs.d/
cp /ctx/system/karg/10-silent-boot.toml /usr/lib/bootc/kargs.d/10-silent-boot.toml

# Persistence & Management Scripts
cp /ctx/bin/seal-os.sh /usr/bin/seal-os
cp /ctx/bin/als /usr/bin/als
chmod +x /usr/bin/seal-os
chmod +x /usr/bin/als

echo "Tweaks applied."