#!/usr/bin/bash
set -ex

echo "Copying over default system configurations and files"

# Copy system files (configs, branding assets, etc.)
cp -drf /ctx/system/* /

# Remove KDE-only config on non-KDE variants
if [[ "${DESKTOP_ENV,,}" != "kde" ]]; then
	rm -f /etc/xdg/kcm-about-distrorc
fi

# Install logo aliases into icon-theme paths used by KDE/Freedesktop consumers.
ICON_SRC="/usr/share/pixmaps/fe02-logo.svg"
ICON_GRAY_SRC="/usr/share/pixmaps/fe02-logo-gray.svg"
ICON_WHITE_SRC="/usr/share/pixmaps/fe02-logo-white.svg"
ICON_DIRS=(
	"/usr/share/icons/hicolor/scalable/apps"
	"/usr/share/icons/hicolor/scalable/places"
)

for dir in "${ICON_DIRS[@]}"; do
	mkdir -p "${dir}"
	cp -f "${ICON_SRC}" "${dir}/fe02-logo.svg"
	cp -f "${ICON_GRAY_SRC}" "${dir}/fe02-logo-gray.svg"
	cp -f "${ICON_WHITE_SRC}" "${dir}/fe02-logo-white.svg"
	cp -f "${ICON_SRC}" "${dir}/distributor-logo.svg"
done

mkdir -p /usr/share/pixmaps
cp -f "${ICON_SRC}" /usr/share/pixmaps/distributor-logo.svg
cp -f "${ICON_WHITE_SRC}" /usr/share/pixmaps/distributor-logo-white.svg

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
	gtk-update-icon-cache -f /usr/share/icons/hicolor || true
fi

echo "Removing upstream Fedora logo assets"
find /usr/share/pixmaps /usr/share/icons/hicolor -type f -name 'fedora-logo*' -delete 2>/dev/null || true

echo "Verifying branding assets in image root"
BRANDING_PATHS=(
	"/usr/share/pixmaps/fe02-logo.svg"
	"/usr/share/pixmaps/fe02-logo-gray.svg"
	"/usr/share/pixmaps/fe02-logo-white.svg"
	"/usr/share/pixmaps/distributor-logo.svg"
	"/usr/share/pixmaps/distributor-logo-white.svg"
	"/usr/share/icons/hicolor/scalable/apps/fe02-logo.svg"
	"/usr/share/icons/hicolor/scalable/apps/fe02-logo-gray.svg"
	"/usr/share/icons/hicolor/scalable/apps/fe02-logo-white.svg"
	"/usr/share/icons/hicolor/scalable/apps/distributor-logo.svg"
	"/usr/share/icons/hicolor/scalable/places/distributor-logo.svg"
	"/usr/share/icons/hicolor/scalable/places/fe02-logo-gray.svg"
	"/usr/share/icons/hicolor/scalable/places/fe02-logo-white.svg"
	"/usr/share/plymouth/themes/spinner/watermark.png"
	"/usr/share/fastfetch/presets/fe02/fe02-ascii.txt"
	"/usr/share/fastfetch/presets/fe02/fe02-fastfetch.jsonc"
)

if [[ "${DESKTOP_ENV,,}" == "kde" ]]; then
	BRANDING_PATHS+=("/etc/xdg/kcm-about-distrorc")
fi

for path in "${BRANDING_PATHS[@]}"; do
	if [[ -f "${path}" ]]; then
		echo "[ok] ${path}"
	else
		echo "[missing] ${path}"
		exit 1
	fi
done

FEDORA_LOGO_HITS="$(find /usr/share/pixmaps /usr/share/icons/hicolor -type f -name 'fedora-logo*' -print 2>/dev/null || true)"
if [[ -n "${FEDORA_LOGO_HITS}" ]]; then
	echo "Found forbidden Fedora logo assets:"
	echo "${FEDORA_LOGO_HITS}"
	exit 1
fi

echo "Copying done"