#!/usr/bin/bash
set -ex

echo "Copying over default system configurations and files"

# Copy system files (configs, branding assets, etc.)
cp -drf /ctx/system/* /

echo "Copying done"