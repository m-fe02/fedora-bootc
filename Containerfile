ARG FEDORA_MAJOR_VERSION=42
ARG FEDORA_DE=silverblue

FROM quay.io/fedora-ostree-desktops/${FEDORA_DE}:${FEDORA_MAJOR_VERSION}

# Create a symlink for /opt to redirect writes to /var/opt
RUN mkdir -p /var/opt && \
    ln -sfn /var/opt /opt

# Add the Brave browser repository and GPG key
RUN dnf install -y dnf-plugins-core && \
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

# Install the Brave browser and remove Firefox
RUN dnf remove -y firefox 

RUN dnf in -y neovim \
    brave-browser && \
    dnf clean all && \
    systemctl set-default graphical.target
