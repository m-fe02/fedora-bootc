ARG FEDORA_MAJOR_VERSION=42
ARG FEDORA_DE=silverblue

FROM quay.io/fedora-ostree-desktops/${FEDORA_DE}:${FEDORA_MAJOR_VERSION}

# Add the Brave browser repository
RUN curl -fsSLo /etc/yum.repos.d/brave-browser.repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo && \
    rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# Install Brave Browser using rpm-ostree
RUN rpm-ostree install brave-browser

# Remove Firefox
RUN dnf remove -y firefox

RUN dnf in -y neovim &&\
    dnf clean all

# Set the default target to graphical
RUN systemctl set-default graphical.target
