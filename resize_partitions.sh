#!/bin/bash
# OnePlus 6 AGNOS 分区调整脚本
# 此脚本将 system 分区从 2.8GB 扩容到 15GB
# 警告：此操作将删除所有数据，请确保已备份重要数据！

set -e

echo "========================================="
echo "  OnePlus 6 AGNOS 分区调整脚本"
echo "========================================="
echo ""
echo "警告：此操作将删除所有数据！"
echo "请确保已备份重要数据！"
echo ""
echo "按 Ctrl+C 取消，按 Enter 继续..."
read

echo ""
echo "开始分区调整..."
echo ""

# 删除旧分区
echo "[1/5] 删除旧分区 (system_a, system_b, odm_a, odm_b, userdata)..."
sgdisk --delete=13 /dev/block/sda
sgdisk --delete=14 /dev/block/sda
sgdisk --delete=15 /dev/block/sda
sgdisk --delete=16 /dev/block/sda
sgdisk --delete=17 /dev/block/sda
echo "  ✓ 旧分区已删除"

# 创建新分区
echo "[2/5] 创建新的 system_a 分区 (15GB)..."
sgdisk --new=13:85824:4194303 --change-name=13:system_a --typecode=13:8300 /dev/block/sda
echo "  ✓ system_a 分区已创建"

echo "[3/5] 创建新的 system_b 分区 (15GB)..."
sgdisk --new=14:4194304:8323327 --change-name=14:system_b --typecode=14:8300 /dev/block/sda
echo "  ✓ system_b 分区已创建"

echo "[4/5] 创建新的 userdata 分区 (85GB)..."
sgdisk --new=17:8323328:30437370 --change-name=17:userdata --typecode=17:8300 /dev/block/sda
echo "  ✓ userdata 分区已创建"

# 格式化分区
echo "[5/5] 格式化新分区..."
mke2fs -t ext4 /dev/block/by-name/system_a
echo "  ✓ system_a 已格式化"

mke2fs -t ext4 /dev/block/by-name/system_b
echo "  ✓ system_b 已格式化"

mke2fs -t ext4 /dev/block/by-name/userdata
echo "  ✓ userdata 已格式化"

# 验证分区表
echo ""
echo "验证分区表..."
sgdisk -p /dev/block/sda

echo ""
echo "========================================="
echo "  分区调整完成！"
echo "========================================="
echo ""
echo "新的分区布局："
echo "  system_a:  15 GB (2.8GB → 15GB)"
echo "  system_b:  15 GB (2.8GB → 15GB)"
echo "  userdata:  85 GB (110GB → 85GB)"
echo ""
echo "下一步："
echo "  1. 重启到 Fastboot 模式: reboot bootloader"
echo "  2. 执行刷机脚本: ./flash_all.sh"
echo ""
