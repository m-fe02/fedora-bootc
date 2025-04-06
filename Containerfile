ARG FEDORA_MAJOR_VERSION=42
ARG FEDORA_DE=silverblue

FROM quay.io/fedora-ostree-desktops/${FEDORA_DE}:${FEDORA_MAJOR_VERSION}

# Add the Visual Studio Code repository and GPG key
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo

# Remove Firefox and its language packs from the base image
RUN dnf remove -y firefox firefox-langpacks && \
    dnf clean all

# Install additional tools
RUN dnf install -y neovim code && \
    dnf clean all

# Set the default target to graphical
RUN systemctl set-default graphical.target
