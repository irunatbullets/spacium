#!/bin/bash
set -ouex pipefail

IMAGE_NAME="${IMAGE_NAME:-spacium}"
IMAGE_VARIANT="${IMAGE_VARIANT:-}"

if [ -z "$IMAGE_VARIANT" ]; then
  FULL_NAME="$IMAGE_NAME"
else
  FULL_NAME="${IMAGE_NAME}-${IMAGE_VARIANT}"
fi

IMAGE_REF="ostree-image-signed:docker://ghcr.io/irunatbullets/${FULL_NAME}"

dnf5 -y copr enable irunatbullets/spacium-extras
dnf5 -y copr enable duxlabs/dms
dnf5 -y copr enable duxlabs/dux-repo

dnf5 -y install \
    acl \
    bluetui \
    breakpad \
    cliphist \
    cava \
    dux-calendar-git \
    dux-search \
    dgop \
    dms \
    dux-greeter \
    greetd \
    ghostty \
    material-symbols-fonts \
    matugen \
    niri \
    qt6-qt5compat \
    qt6-qtimageformats \
    qt6-qtmultimedia \
    qt6-qtsvg \
    quickshell-git \
    tmux \
    wl-clipboard \
    xwayland-satellite

dnf5 -y copr disable irunatbullets/spacium-extras
dnf5 -y copr disable duxlabs/dms
dnf5 -y copr disable duxlabs/dux-repo

systemctl enable podman.socket

systemctl --global enable dms

systemctl disable gdm
systemctl enable greetd

mkdir -p /var/cache/dms-greeter

tee /usr/lib/sysusers.d/greeter.conf > /dev/null <<'EOF'
g greeter 767
u greeter 767 "greetd greeter" /var/lib/greeter
EOF

mkdir -p /var/lib/greeter
chown 767:767 /var/lib/greeter

mkdir -p /usr/lib/systemd/user/graphical-session.target.wants

ln -s /usr/lib/systemd/user/spacium.service \
    /usr/lib/systemd/user/graphical-session.target.wants/spacium.service

ln -s /usr/lib/systemd/user/dsearch.service \
    /usr/lib/systemd/user/graphical-session.target.wants/dsearch.service

jq \
  --arg name "$FULL_NAME" \
  --arg ref "$IMAGE_REF" \
  --arg tag "${IMAGE_VARIANT:-latest}" \
  '
  .["image-name"]=$name |
  .["image-ref"]=$ref |
  .["image-tag"]=$tag
  ' \
  /usr/share/ublue-os/image-info.json \
  > /tmp/image-info.json && mv /tmp/image-info.json /usr/share/ublue-os/image-info.json

