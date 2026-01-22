#!/bin/bash
set -e

MM_VERSION="1.18.8"
LIBQMI_VERSION="1.30.6"
PROVIDER_INFO_VERSION="20220511"

cd /tmp

# TODO: clean up these build time dependencies
apt install -y --no-install-recommends python3 python3-pip python3-setuptools python3-wheel ninja-build
pip3 install --user meson
export PATH=$PATH:/root/.local/bin

# build mobile-broadband-provider-info
apt install -y --no-install-recommends xsltproc
LOCAL_PROVIDER_INFO="$(dirname "$0")/../../local_sources/mobile-broadband-provider-info"
if [ -d "$LOCAL_PROVIDER_INFO" ]; then
    cp -r "$LOCAL_PROVIDER_INFO" /tmp/
    cd /tmp/mobile-broadband-provider-info
else
    echo "警告: 本地 mobile-broadband-provider-info 目录不存在，使用在线克隆"
    git clone -b $PROVIDER_INFO_VERSION --depth 1 https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info.git
    cd mobile-broadband-provider-info
fi
./autogen.sh
./configure
make install

# build libqmi
cd /tmp
# Install minimal dependencies for libqmi
# Skip gobject-introspection and libgirepository1.0-dev to avoid segmentation fault in QEMU
apt install -y --no-install-recommends libgudev-1.0-dev help2man bash-completion

LOCAL_LIBQMI="$(dirname "$0")/../../local_sources/libqmi"
if [ -d "$LOCAL_LIBQMI" ]; then
    cp -r "$LOCAL_LIBQMI" /tmp/
    cd /tmp/libqmi
else
    echo "警告: 本地 libqmi 目录不存在，使用在线克隆"
    git clone -b $LIBQMI_VERSION --depth 1 https://gitlab.freedesktop.org/mobile-broadband/libqmi.git
    cd libqmi
fi
meson setup build --prefix=/usr --libdir=/usr/lib/aarch64-linux-gnu -Dmbim_qmux=false -Dqrtr=false -Dintrospection=false
ninja -C build
ninja -C build install

# build ModemManager
cd /tmp
apt install -y --no-install-recommends gettext libpolkit-gobject-1-dev

LOCAL_MM="$(dirname "$0")/../../local_sources/ModemManager"
if [ -d "$LOCAL_MM" ]; then
    cp -r "$LOCAL_MM" /tmp/
    cd /tmp/ModemManager
else
    echo "警告: 本地 ModemManager 目录不存在，使用在线克隆"
    git clone -b $MM_VERSION --depth 1 https://gitlab.freedesktop.org/mobile-broadband/ModemManager.git
    cd ModemManager
fi
meson setup build \
      --prefix=/usr \
      --libdir=/usr/lib/aarch64-linux-gnu \
      --sysconfdir=/etc \
      --buildtype=release \
      -Dqmi=true \
      -Dmbim=false \
      -Dqrtr=false \
      -Dintrospection=false \
      -Dplugin_foxconn=disabled \
      -Dplugin_dell=disabled \
      -Dplugin_altair_lte=disabled \
      -Dplugin_fibocom=disabled

ninja -C build
ninja -C build install
