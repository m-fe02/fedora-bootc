ARG FEDORA_MAJOR_VERSION=44
ARG BASE_IMAGE_NAME
ARG DESKTOP_ENV
ARG GAMING=false

FROM scratch AS ctx
COPY build_files/ /
COPY system/ /system/
COPY cosign.pub /

FROM quay.io/fedora-ostree-desktops/${BASE_IMAGE_NAME}:${FEDORA_MAJOR_VERSION}

ARG DESKTOP_ENV
ARG GAMING
ENV DESKTOP_ENV=${DESKTOP_ENV}
ENV GAMING=${GAMING}

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    bash /ctx/scripts/install.sh && \
    bash /ctx/scripts/post-install.sh

RUN rm -rf /opt && ln -s /var/opt /opt && \
    systemctl set-default graphical.target

CMD ["/sbin/init"]

RUN ["bootc", "container", "lint"]
