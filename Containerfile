ARG BASE_IMAGE=ghcr.io/ublue-os/bazzite-gnome:stable
ARG IMAGE_TAG=latest

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS buildctx
COPY build_files /ctx/

FROM ${BASE_IMAGE} AS base

COPY system_files/etc/ /etc/
COPY system_files/usr/ /usr/

# Import upstream DMS Niri defaults into skel.
# This intentionally fails if DMS changes its config layout.
RUN git clone --depth=1 https://github.com/AvengeMedia/DankMaterialShell.git /tmp/dms && \
    test -f /tmp/dms/core/internal/config/embedded/niri.kdl && \
    install -d /etc/skel/.config/niri/dms && \
    git -C /tmp/dms rev-parse HEAD > /etc/skel/.config/niri/.dms-config-commit && \
    install -Dm644 \
        /tmp/dms/core/internal/config/embedded/niri.kdl \
        /etc/skel/.config/niri/config.kdl && \
    for f in /tmp/dms/core/internal/config/embedded/niri-*.kdl; do \
        name="$(basename "$f")"; \
        name="${name#niri-}"; \
        install -Dm644 "$f" "/etc/skel/.config/niri/dms/$name"; \
    done && \
    rm -rf /tmp/dms

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.
RUN --mount=type=bind,from=buildctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint

