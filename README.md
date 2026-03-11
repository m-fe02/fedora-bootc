# HackPad_OS

This project provides custom OS images based on [Fedora bootC](https://docs.fedoraproject.org/en-US/fedora-coreos/bootc/), branded as HackPad_OS.

The images are built automatically using GitHub Actions and are available on `ghcr.io`.

## Getting Started

You can switch your OS to one of the HackPad_OS images using the `bootc` command.

**Warning:** This will replace your current operating system with the selected HackPad_OS image.

### Silverblue (GNOME)

```bash
sudo bootc switch --reboot ghcr.io/m-fe02/hackpad-os:silverblue
```

### Kinoite (KDE)

```bash
sudo bootc switch --reboot ghcr.io/m-fe02/hackpad-os:kinoite
```

### Cosmic Atomic (Cosmic)

```bash
sudo bootc switch --reboot ghcr.io/m-fe02/hackpad-os:cosmic-atomic
```

## Post-Installation Utilities

After you have switched to a HackPad_OS image and rebooted, there are two utilities available to you: `seal-os` and `hpsw`.

### `seal-os`

The `seal-os` utility enables signature verification for OS updates. This ensures that your system will only accept signed updates from the `ghcr.io/m-fe02/hackpad-os` repository.

To seal your system, run the following command:

```bash
sudo seal-os
```

You will be prompted to reboot after the process is complete.

### `hpsw` (HackPad_OS Switcher)

The `hpsw` utility is a simple script to switch between the different HackPad_OS desktop variants.

**Usage:**

```bash
hpsw [variant | command]
```

**Variants:**

*   `cosmic`: Switch to the Cosmic Atomic variant.
*   `silver`: Switch to the Silverblue (GNOME) variant.
*   `kinoite`: Switch to the Kinoite (KDE) variant.

**Commands:**

*   `status`: Show the current booted and staged images.
*   `upgrade`: Upgrade to the latest version of the current image.

**Example:**

To switch to the Kinoite variant, run the following command:

```bash
hpsw kinoite
```

You will be prompted to reboot after the switch is staged.

## Building Locally (Optional)

If you want to build the images locally, you can use the provided `Containerfile`. You need a container runtime that supports BuildKit, like Podman or Docker.

### Build Arguments

*   `BASE_IMAGE_NAME`: The name of the base image to use from `quay.io/fedora-ostree-desktops`.
*   `DESKTOP_ENV`: The desktop environment to install. This should correspond to the package list in `build_files/pkgs/`.
*   `FEDORA_MAJOR_VERSION`: The Fedora major version to use. Defaults to `43`.

### Build Examples

#### Silverblue (GNOME)

```bash
podman build \
    --build-arg BASE_IMAGE_NAME=silverblue \
    --build-arg DESKTOP_ENV=gnome \
    -t hackpad-os:silverblue .
```

#### Kinoite (KDE)

```bash
podman build \
    --build-arg BASE_IMAGE_NAME=kinoite \
    --build-arg DESKTOP_ENV=kde \
    -t hackpad-os:kinoite .
```

#### Cosmic Atomic (Cosmic)

```bash
podman build \
    --build-arg BASE_IMAGE_NAME=cosmic-atomic \
    --build-arg DESKTOP_ENV=cosmic \
    -t hackpad-os:cosmic-atomic .
```
