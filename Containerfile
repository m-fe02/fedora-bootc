ARG FEDORA_MAJOR_VERSION=42
ARG FEDORA_DE=silverblue

FROM quay.io/fedora-ostree-desktops/${FEDORA_DE}:${FEDORA_MAJOR_VERSION}

# Add the Brave browser repository and GPG key
RUN dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo && \
    rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# Install the Brave browser and remove Firefox
RUN dnf remove -y firefox 

RUN dnf in -y neovim \
    brave-browser && \
    dnf clean all && \
    systemctl set-default graphical.target
