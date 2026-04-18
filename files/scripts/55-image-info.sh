#!/usr/bin/bash
set -ex

echo "Applying custom image info and labels"

declare -A IMAGE_INFO=(
    ["NAME"]="Fe02-OS"
    ["PRETTY_NAME"]="Fe02-OS"
    ["ID"]="fe02"
    ["ID_LIKE"]="linux"
    ["LOGO"]="fe02-logo-gray"
    ["VERSION"]="Fe02-OS"
    ["IMAGE_ID"]="fe02"
    ["VARIANT"]="Fe02-OS"
    ["VARIANT_ID"]="fe02"
    ["BOOTLOADER_NAME"]="Fe02-OS"
    ["DEFAULT_HOSTNAME"]="fe02"
    ["HOME_URL"]="https://github.com/fe02/Fe02-OS"
    ["DOCUMENTATION_URL"]="https://github.com/fe02/Fe02-OS"
    ["SUPPORT_URL"]="https://github.com/fe02/Fe02-OS/issues"
    ["BUG_REPORT_URL"]="https://github.com/fe02/Fe02-OS/issues"
)

REMOVE_KEYS=(
    "CPE_NAME"
    "SUPPORT_END"
    "REDHAT_BUGZILLA_PRODUCT"
    "REDHAT_BUGZILLA_PRODUCT_VERSION"
    "REDHAT_SUPPORT_PRODUCT"
    "REDHAT_SUPPORT_PRODUCT_VERSION"
)

OS_RELEASE_FILE="/usr/lib/os-release"
# Remove inherited upstream vendor fields that should not leak into custom branding.
for key in "${REMOVE_KEYS[@]}"; do
    sed -i "/^${key}=/d" "${OS_RELEASE_FILE}"
done

# Iterate over IMAGE_INFO key-value pairs
for key in "${!IMAGE_INFO[@]}"; do
    value="${IMAGE_INFO[${key}]}"
    echo "Setting ${key}=${value}"
    sed -i "s|^${key}=.*|${key}=\"${value}\"|" "${OS_RELEASE_FILE}"
    # If the key does not exist, append it to the os-release file
    grep -q "^${key}=" "${OS_RELEASE_FILE}" || echo "${key}=\"${value}\"" >> "${OS_RELEASE_FILE}"
done

echo "Checking for forbidden distro branding in ${OS_RELEASE_FILE}"
if grep -Eiq 'fedora|kinoite|silverblue|cosmic( |-)?atomic' "${OS_RELEASE_FILE}"; then
    echo "Found forbidden distro branding references:"
    grep -Ein 'fedora|kinoite|silverblue|cosmic( |-)?atomic' "${OS_RELEASE_FILE}"
    exit 1
fi

echo "Applied image info"

echo "Full output of: ${OS_RELEASE_FILE}"
cat "${OS_RELEASE_FILE}"