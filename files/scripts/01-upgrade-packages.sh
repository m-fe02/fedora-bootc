#!/bin/bash
set -ex

# Step 1: Upgrade packages (excluding kernel to avoid conflicts)
dnf upgrade -y --exclude=kernel*,dracut*