ARG FEDORA_MAJOR_VERSION=42
ARG FEDORA_DE=silverblue

FROM quay.io/fedora-ostree-desktops/${FEDORA_DE}:${FEDORA_MAJOR_VERSION}

# Add the Visual Studio Code repository and GPG key
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo

# Temporarily create /opt/brave.com as a real directory
RUN [ ! -d /opt/brave.com ] && mkdir -p /opt/brave.com

# Add the Brave browser repository and install Brave
RUN dnf install -y dnf-plugins-core && \
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo && \
    dnf install -y brave-browser && \
    dnf clean all

# Relocate /opt/brave.com to /var/opt/brave.com and create a symlink
RUN mv /opt/brave.com /var/opt/brave.com && \
    ln -sfn /var/opt/brave.com /opt/brave.com

# Install additional tools
RUN dnf install -y neovim code && \
    dnf clean all

# Set the default target to graphical
RUN systemctl set-default graphical.target
