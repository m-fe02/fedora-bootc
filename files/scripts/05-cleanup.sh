#!/bin/bash
set -ex

# Step 5: Final cleanup

# Package manager cleanup
dnf autoremove -y
dnf clean all
rm -rf /var/lib/dnf /var/log/dnf5.log

# Run container cleanup script
bash /ctx/scripts/cleanup-container.sh