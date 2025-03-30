ARG FEDORA_MAJOR_VERSION=42
ARG FEDORA_DE=silverblue

FROM quay.io/fedora-ostree-desktops/${FEDORA_DE}:${FEDORA_MAJOR_VERSION}

# Add the Brave browser repository and GPG key
RUN dnf install -y dnf-plugins-core && \
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

# Create the symlink for Brave browser before installation
RUN mkdir -p /opt/brave.com/brave && \
    ln -sf /opt/brave.com/brave/brave-browser /usr/bin/brave-browser

# Install the Brave browser and remove Firefox
RUN dnf remove -y firefox 

RUN dnf in -y neovim \
    brave-browser && \
    dnf clean all

# Set the default target to graphical
RUN systemctl set-default graphical.target
