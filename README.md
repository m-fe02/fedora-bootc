# Adamant Linux

This project provides custom OS images based on [Fedora bootC](https://docs.fedoraproject.org/en-US/fedora-coreos/bootc/), branded as Adamant Linux.

The images are built automatically using GitHub Actions and are available on `ghcr.io`.

## Getting Started

You can switch your OS to one of the Adamant Linux images using the `bootc` command.

**Warning:** This will replace your current operating system with the selected Adamant Linux image.

### Adamant Linux GNOME

```bash
sudo bootc switch --reboot ghcr.io/m-fe02/adamant-linux:gnome
```

### Adamant Linux GNOME (Gaming)

```bash
sudo bootc switch --reboot ghcr.io/m-fe02/adamant-linux:gnome-gaming
```

### Adamant Linux KDE

```bash
sudo bootc switch --reboot ghcr.io/m-fe02/adamant-linux:kde
```

### Adamant Linux KDE (Gaming)

```bash
sudo bootc switch --reboot ghcr.io/m-fe02/adamant-linux:kde-gaming
```

### Adamant Linux Cosmic

```bash
sudo bootc switch --reboot ghcr.io/m-fe02/adamant-linux:cosmic
```

### Adamant Linux Cosmic (Gaming)

```bash
sudo bootc switch --reboot ghcr.io/m-fe02/adamant-linux:cosmic-gaming
```

## Post-Installation Utilities

After you have switched to a Adamant Linux image and rebooted, there are two utilities available to you: `seal-os` and `als`.

### `seal-os`

The `seal-os` utility enables signature verification for OS updates. This ensures that your system will only accept signed updates from the `ghcr.io/m-fe02/adamant-linux` repository.

To seal your system, run the following command:

```bash
sudo seal-os
```

You will be prompted to reboot after the process is complete.

### `als` (Adamant Linux Switcher)

The `als` utility is a simple script to switch between the different Adamant Linux desktop variants.

**Usage:**

```bash
als [variant | command]
```

**Variants:**

*   `cosmic`: Switch to the Adamant Linux Cosmic variant.
*   `cosmic-gaming`: Switch to the Adamant Linux Cosmic (Gaming) variant.
*   `gnome`: Switch to the Adamant Linux GNOME variant.
*   `gnome-gaming`: Switch to the Adamant Linux GNOME (Gaming) variant.
*   `kde`: Switch to the Adamant Linux KDE variant.
*   `kde-gaming`: Switch to the Adamant Linux KDE (Gaming) variant.

**Commands:**

*   `status`: Show the current booted and staged images.
*   `upgrade`: Upgrade to the latest version of the current image.

**Example:**

To switch to the Kinoite variant, run the following command:

```bash
als kde
```

You will be prompted to reboot after the switch is staged.