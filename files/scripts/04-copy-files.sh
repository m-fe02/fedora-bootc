#!/usr/bin/bash
set -ex

echo "Copying over default system configurations and files"

# Copy system files (configs, branding assets, etc.)
cp -drf /ctx/system/* /

echo "Verifying branding assets in image root"
BRANDING_PATHS=(
	"/usr/share/pixmaps/fe02-logo.svg"
	"/usr/share/pixmaps/fe02-logo-white.svg"
	"/usr/share/plymouth/themes/spinner/watermark.png"
	"/usr/share/fastfetch/presets/fe02/fe02-ascii.txt"
	"/usr/share/fastfetch/presets/fe02/fe02-fastfetch.jsonc"
)

for path in "${BRANDING_PATHS[@]}"; do
	if [[ -f "${path}" ]]; then
		echo "[ok] ${path}"
	else
		echo "[missing] ${path}"
		exit 1
	fi
done

echo "Copying done"