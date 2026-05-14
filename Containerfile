ARG FEDORA_MAJOR_VERSION
ARG BASE_IMAGE_NAME
ARG GAMING=false

FROM scratch AS ctx
COPY files /
COPY cosign.pub /

FROM ${BASE_IMAGE_NAME}:${FEDORA_MAJOR_VERSION}

ARG DESKTOP_ENV
ARG GAMING
ENV DESKTOP_ENV=${DESKTOP_ENV}
ENV GAMING=${GAMING}

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    bash /ctx/scripts/00-setup.sh

CMD ["/sbin/init"]

RUN ["bootc", "container", "lint"]
