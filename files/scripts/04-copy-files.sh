#!/usr/bin/bash
set -ex

echo "Copying over default system configurations and files"

# Copy system files (configs, branding assets, etc.)
cp -drf /ctx/system/* /

# Install logo aliases into icon-theme paths used by KDE/Freedesktop consumers.
ICON_SRC="/usr/share/pixmaps/fe02-logo.svg"
ICON_SYMBOLIC_SRC="/usr/share/pixmaps/fe02-logo-white.svg"
ICON_DIRS=(
	"/usr/share/icons/hicolor/scalable/apps"
	"/usr/share/icons/hicolor/scalable/places"
)

ICON_SYMBOLIC_DIRS=(
	"/usr/share/icons/hicolor/symbolic/apps"
	"/usr/share/icons/hicolor/symbolic/places"
)

for dir in "${ICON_DIRS[@]}"; do
	mkdir -p "${dir}"
	cp -f "${ICON_SRC}" "${dir}/fe02-logo.svg"
	cp -f "${ICON_SRC}" "${dir}/distributor-logo.svg"
	cp -f "${ICON_SRC}" "${dir}/fedora-logo-icon.svg"
done

for dir in "${ICON_SYMBOLIC_DIRS[@]}"; do
	mkdir -p "${dir}"
	cp -f "${ICON_SYMBOLIC_SRC}" "${dir}/distributor-logo-symbolic.svg"
	cp -f "${ICON_SYMBOLIC_SRC}" "${dir}/fedora-logo-symbolic.svg"
done

mkdir -p /usr/share/pixmaps
cp -f "${ICON_SRC}" /usr/share/pixmaps/distributor-logo.svg
cp -f "${ICON_SRC}" /usr/share/pixmaps/fedora-logo-icon.svg

echo "Verifying branding assets in image root"
BRANDING_PATHS=(
	"/usr/share/pixmaps/fe02-logo.svg"
	"/usr/share/pixmaps/fe02-logo-white.svg"
	"/usr/share/pixmaps/distributor-logo.svg"
	"/usr/share/pixmaps/fedora-logo-icon.svg"
	"/usr/share/icons/hicolor/scalable/apps/fe02-logo.svg"
	"/usr/share/icons/hicolor/scalable/apps/distributor-logo.svg"
	"/usr/share/icons/hicolor/scalable/apps/fedora-logo-icon.svg"
	"/usr/share/icons/hicolor/scalable/places/distributor-logo.svg"
	"/usr/share/icons/hicolor/symbolic/apps/distributor-logo-symbolic.svg"
	"/usr/share/icons/hicolor/symbolic/apps/fedora-logo-symbolic.svg"
	"/usr/share/icons/hicolor/symbolic/places/distributor-logo-symbolic.svg"
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