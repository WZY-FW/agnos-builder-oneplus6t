#!/bin/bash -e

# 优化 1: 设置编译线程数，避免 QEMU 在高并发下死锁，同时保留一定效率
# 如果是 QEMU 环境，建议限制核心数（比如 4 核），太高容易崩
JOBS=$(nproc)
# 如果发现经常卡死，可以将下面这就话改成 JOBS=4

echo "Building FFmpeg with $JOBS jobs..."

# 安装目录准备
WORK_DIR="/tmp/ffmpeg_build"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# 优化 2: 增加断点续传，避免每次重试都重新下载
if [ ! -f "ffmpeg-4.2.2.tar.bz2" ]; then
    wget -c https://ffmpeg.org/releases/ffmpeg-4.2.2.tar.bz2
fi

# 解压前先清理旧目录，防止配置残留导致莫名其妙的错误
rm -rf ffmpeg-4.2.2
tar xf ffmpeg-4.2.2.tar.bz2
cd ffmpeg-4.2.2

# 优化 3: 关键修改！
# --disable-asm: 解决 configure 阶段的 Segmentation fault (QEMU 崩溃的核心原因)
# --disable-doc/programs: 不编译文档和命令行工具(ffmpeg/ffprobe)，只编库，大幅加快速度
# --prefix=/usr: 确保 checkinstall 打包后路径符合系统标准
./configure \
    --prefix=/usr \
    --enable-shared \
    --disable-static \
    --disable-all \
    --disable-asm \
    --disable-doc \
    --disable-programs \
    --enable-avcodec \
    --enable-avformat \
    --enable-swscale \
    --enable-pic # 确保生成位置无关代码，防止链接错误

make -j"$JOBS"

# 优化 4: checkinstall 规范化
# 明确指定版本号，方便后续管理
# --fstrans=no: 在某些 chroot/docker 环境下必须禁用文件系统转换，否则会失败
checkinstall -yD \
    --install=no \
    --fstrans=no \
    --pkgname=ffmpeg \
    --pkgversion="4.2.2-custom" \
    --pkgrelease="1" \
    --maintainer="agnos-builder"

mv ffmpeg*.deb /tmp/ffmpeg.deb

# 清理战场
cd /tmp
rm -rf "$WORK_DIR"
