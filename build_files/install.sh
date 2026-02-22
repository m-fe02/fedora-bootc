#!/bin/bash
set -ex

# Setup Tailscale Repo
curl -s -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

# Determine which package list to use (passed as an ARG)
PKGLIST="/ctx/pkgs/${DESKTOP_ENV:-cosmic}.txt"

# Perform DNF transaction
dnf upgrade -y --exclude=kernel*
dnf remove -y $(grep -v '^#' /ctx/pkgs/remove.txt | xargs) || true
dnf install -y $(grep -v '^#' "$PKGLIST" | xargs)

# Final DNF clean (within the mount)
dnf autoremove -y
