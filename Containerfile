ARG FEDORA_MAJOR_VERSION=43
ARG BASE_IMAGE_NAME
ARG DESKTOP_ENV

FROM scratch AS ctx
COPY build_files/ /
COPY system/ /system/
COPY cosign.pub /

FROM quay.io/fedora-ostree-desktops/${BASE_IMAGE_NAME}:${FEDORA_MAJOR_VERSION}

RUN --mount=type=bind,from=ctx,src=/,dst=/ctx \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/log \
    --mount=type=tmpfs,target=/tmp \
    DESKTOP_ENV=${DESKTOP_ENV} bash /ctx/scripts/install.sh && \
    bash /ctx/scripts/post-install.sh

RUN rm -rf /opt && ln -s /var/opt /opt && 
    systemctl set-default graphical.target

CMD ["/sbin/init"]

RUN ["bootc", "container", "lint"]
