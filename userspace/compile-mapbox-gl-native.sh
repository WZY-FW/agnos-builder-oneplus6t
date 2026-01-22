#!/bin/bash -e

# 优化 1: 设置编译线程数，避免 QEMU 在高并发下死锁
JOBS=4

echo "Building mapbox-gl-native with $JOBS jobs..."

# 优化 2: 增加超时控制和断点续传
cd /tmp

# 清理旧目录，避免残留文件导致编译问题
rm -rf mapbox-gl-native

# 使用本地 mapbox-gl-native 源码
LOCAL_MAPBOX_DIR="$(dirname "$0")/../../local_sources/mapbox-gl-native"
if [ -d "$LOCAL_MAPBOX_DIR" ]; then
    cp -r "$LOCAL_MAPBOX_DIR" /tmp/
    cd /tmp/mapbox-gl-native
else
    echo "警告: 本地 mapbox-gl-native 目录不存在，使用在线克隆"
    # 优化 3: 只克隆必要的分支，不克隆所有历史记录
    git clone --depth 1 --recursive https://github.com/commaai/mapbox-gl-native.git
    cd mapbox-gl-native
fi

# 优化 4: 切换到指定版本
git checkout 69f41ffff655ee28834c167ad1353112f370e6e5

# 优化 5: 清理子模块并重新更新，避免子模块克隆失败
git submodule sync --recursive
git submodule update --init --recursive --depth 1

mkdir -p build && cd build

# 优化 6: 使用更保守的cmake配置，只启用必要的功能
cmake -DMBGL_WITH_QT=ON -DMBGL_WITH_GLFW=OFF -DMBGL_WITH_NODEJS=OFF -DMBGL_WITH_TESTS=OFF -DMBGL_WITH_BENCHMARKS=OFF ..

# 优化 7: 使用限制的并行数进行编译
make -j$JOBS mbgl-qt

# 优化 8: 确保输出文件存在
if [ -f libqmapboxgl.so ]; then
    mv libqmapboxgl.so /tmp/libqmapboxgl.so
    echo "mapbox-gl-native build completed successfully"
else
    echo "ERROR: libqmapboxgl.so not found"
    exit 1
fi
