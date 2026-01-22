#!/bin/bash -e

# 优化 1: 设置编译线程数，避免 QEMU 在高并发下崩溃
# 如果是 QEMU 环境，建议限制核心数，太高容易导致段错误
JOBS=$(nproc)
# 使用更保守的线程数，最多4核
if [ $JOBS -gt 4 ]; then
  JOBS=4
fi

echo "Building capnproto with $JOBS jobs..."

# 优化 2: 增加断点续传，避免每次重试都重新下载
cd /tmp
VERSION=0.8.0
WORK_DIR="/tmp/capnproto_build"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

if [ ! -f "capnproto-c++-${VERSION}.tar.gz" ]; then
    wget -c https://capnproto.org/capnproto-c++-${VERSION}.tar.gz
fi

# 优化 3: 解压前先清理旧目录，防止配置残留
rm -rf capnproto-c++-${VERSION}
tar xvf capnproto-c++-${VERSION}.tar.gz
cd capnproto-c++-${VERSION}

# 优化 4: 进一步优化编译选项，解决段错误问题
# -O0: 使用最低优化级别，减少QEMU模拟时的编译器压力
# -fno-inline: 避免内联优化导致的问题
# --disable-tests: 跳过测试文件编译，test.c++是段错误的主要来源
CXXFLAGS="-fPIC -O0 -fno-inline" ./configure --prefix=/usr --disable-tests

# 优化 5: 使用单线程编译，彻底避免QEMU环境下的多线程并发问题
# 在QEMU模拟环境中，单线程编译是最稳定的选择
make -j1

# 优化 6: 规范化checkinstall配置
checkinstall -yD \
    --install=no \
    --fstrans=no \
    --pkgname=capnproto \
    --pkgversion="${VERSION}" \
    --pkgrelease="1" \
    --maintainer="agnos-builder"

mv capnproto*.deb /tmp/capnproto.deb

# 优化 7: 清理临时文件
cd /tmp
rm -rf "$WORK_DIR"
