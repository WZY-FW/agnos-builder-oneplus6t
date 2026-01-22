#!/bin/bash -e
# extract_oneplus6_firmware.sh - 从官方ROM提取一加6固件

ROM_FILE=${1:-"oxygen-os.zip"}
OUTPUT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)/userspace/firmware_oneplus6"

echo "从 $ROM_FILE 提取一加6固件到 $OUTPUT_DIR"

# 检查文件是否存在
if [ ! -f "$ROM_FILE" ]; then
    echo "错误: 文件 $ROM_FILE 不存在"
    echo "用法: $0 <rom_file>"
    exit 1
fi

# 检查并安装必要的工具
if ! command -v unzip &> /dev/null; then
    echo "安装 unzip..."
    sudo apt-get install -y unzip
fi

if ! command -v python3 &> /dev/null; then
    echo "安装 python3..."
    sudo apt-get install -y python3
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 检查是否为payload.bin格式
if unzip -l "$ROM_FILE" | grep -q "payload.bin"; then
    echo "检测到 payload.bin 格式"
    
    # 解压payload.bin
    TEMP_DIR=$(mktemp -d)
    unzip -q "$ROM_FILE" "payload.bin" -d "$TEMP_DIR"
    
    # 使用本地 payload dumper
    if [ ! -d "$TEMP_DIR/payload_dumper" ]; then
        LOCAL_PAYLOAD_DUMPER="$(dirname "$0")/../local_sources/payload_dumper"
        if [ -d "$LOCAL_PAYLOAD_DUMPER" ]; then
            cp -r "$LOCAL_PAYLOAD_DUMPER" "$TEMP_DIR/"
        else
            echo "警告: 本地 payload_dumper 目录不存在，使用在线克隆"
            git clone https://github.com/vm03/payload_dumper.git "$TEMP_DIR/payload_dumper"
        fi
    fi
    
    # 提取vendor.img
    python3 "$TEMP_DIR/payload_dumper/payload_dumper.py" --vendor "$TEMP_DIR/payload.bin" -o "$TEMP_DIR/extracted"
    
    # 复制固件文件
    echo "复制固件文件..."
    if [ -d "$TEMP_DIR/extracted/vendor/firmware" ]; then
        cp -r "$TEMP_DIR/extracted/vendor/firmware/"* "$OUTPUT_DIR/"
    fi
    
    # 清理
    rm -rf "$TEMP_DIR"
    echo "固件提取完成: $OUTPUT_DIR"
else
    echo "尝试直接从ZIP提取..."
    unzip -q "$ROM_FILE" -d "$TEMP_DIR"
    
    # 查找固件目录
    FIRMWARE_DIRS=$(find "$TEMP_DIR" -type d -name "firmware" 2>/dev/null)
    
    if [ -n "$FIRMWARE_DIRS" ]; then
        for dir in $FIRMWARE_DIRS; do
            echo "找到固件目录: $dir"
            cp -r "$dir/"* "$OUTPUT_DIR/"
        done
        echo "固件提取完成: $OUTPUT_DIR"
    else
        echo "未找到固件目录，请手动提取"
    fi
    
    rm -rf "$TEMP_DIR"
fi

# 列出提取的文件
echo "提取的文件:"
ls -lh "$OUTPUT_DIR"

exit 0
