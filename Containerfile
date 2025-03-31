ARG FEDORA_MAJOR_VERSION=42
ARG FEDORA_DE=gnome

FROM quay.io/fedora/fedora-bootc:${FEDORA_MAJOR_VERSION}

# Install the desktop environment (GNOME, KDE, or Cosmic)
RUN if [ "$FEDORA_DE" = "gnome" ]; then \
        dnf install -y @workstation-product-environment; \
    elif [ "$FEDORA_DE" = "kde" ]; then \
        dnf install -y @kde-desktop-environment; \
    elif [ "$FEDORA_DE" = "cosmic" ]; then \
        dnf install -y cosmic-desktop cosmic-store; \
    fi && \
    dnf clean all

# Add the Visual Studio Code repository and GPG key
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo

# Install additional tools
RUN dnf install -y neovim code && \
    dnf clean all

# Set the default target to graphical
RUN systemctl set-default graphical.target
