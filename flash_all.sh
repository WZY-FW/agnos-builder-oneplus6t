#!/bin/bash -e
# flash_all.sh - Flash AGNOS to OnePlus 6 (enchilada)
# This script flashes bootloader, kernel, and system image to OnePlus 6

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd $DIR

echo "============================================"
echo "AGNOS Flash Script for OnePlus 6 (enchilada)"
echo "============================================"

# Check for fastboot
if ! command -v fastboot &> /dev/null; then
    echo "错误: fastboot 未安装"
    echo "请安装 Android platform-tools"
    exit 1
fi

# Check device in fastboot mode
echo "检查设备连接..."
DEVICE=$(fastboot devices | grep -i "fastboot" | awk '{print $1}')
if [ -z "$DEVICE" ]; then
    echo "错误: 未找到 fastboot 设备"
    echo "请确保设备已启动到 fastboot 模式"
    exit 1
fi

echo "找到设备: $DEVICE"

# Get device info
MANUFACTURER=$(fastboot getvar manufacturer 2>/dev/null | grep "manufacturer:" | awk '{print $2}')
PRODUCT=$(fastboot getvar product 2>/dev/null | grep "product:" | awk '{print $2}')

echo "设备信息: $MANUFACTURER $PRODUCT"

# Verify it's OnePlus 6
if [[ "$PRODUCT" == "enchilada" ]] || [[ "$PRODUCT" == "oneplus6" ]]; then
    echo "检测到 OnePlus 6 ($PRODUCT)"
else
    echo "警告: 可能不是 OnePlus 6 (检测到: $PRODUCT)"
    read -p "是否继续? (y/n): " CONFIRM
    if [ "$CONFIRM" != "y" ]; then
        echo "取消刷机"
        exit 1
    fi
fi

# OnePlus 6 single partition setup
SYSTEM="system"
VENDOR="vendor"
USERDATA="userdata"
BOOT="boot"

# Format userdata partition
echo ""
echo "============================================"
echo "步骤 1: 格式化 userdata 分区"
echo "============================================"
fastboot format:ext4 userdata
fastboot format:ext4 cache 2>/dev/null || true

# Flash boot image (kernel)
echo ""
echo "============================================"
echo "步骤 2: 刷写 Boot 镜像 (内核)"
echo "============================================"
if [ -f "output/boot.img" ]; then
    fastboot flash boot output/boot.img
    echo "Boot 镜像刷写完成"
else
    echo "错误: output/boot.img 不存在"
    echo "请先运行 ./build_kernel.sh"
    exit 1
fi

# Flash system image (AGNOS)
echo ""
echo "============================================"
echo "步骤 3: 刷写 System 镜像 (AGNOS)"
echo "============================================"
if [ -f "output/system.img" ]; then
    echo "调整 system.img 大小以适配一加6分区..."
    fastboot flash system output/system.img
    echo "System 镜像刷写完成"
else
    echo "错误: output/system.img 不存在"
    echo "请先运行 ./build_system.sh"
    exit 1
fi

# Flash vendor image (if available)
echo ""
echo "============================================"
echo "步骤 4: 刷写 Vendor 镜像 (可选)"
echo "============================================"
if [ -f "output/vendor.img" ]; then
    fastboot flash vendor output/vendor.img
    echo "Vendor 镜像刷写完成"
else
    echo "跳过 vendor 刷写 (output/vendor.img 不存在)"
fi

# Final reboot
echo ""
echo "============================================"
echo "刷机完成!"
echo "============================================"
echo ""
echo "设备将自动重启到 AGNOS 系统"
echo ""
echo "注意事项:"
echo "- 如果设备无法启动，请进入 fastboot 模式并检查日志"
echo "- 确保已解锁 bootloader"
echo "- 首次启动可能需要较长时间"
echo ""
read -p "是否立即重启? (y/n): " REBOOT
if [ "$REBOOT" == "y" ]; then
    fastboot continue
    echo "设备正在重启..."
else
    echo "请手动执行: fastboot continue"
fi

exit 0
