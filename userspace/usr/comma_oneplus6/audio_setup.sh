#!/bin/bash -e
# oneplus6_audio.sh - OnePlus 6 audio configuration for AGNOS

echo "配置 OnePlus 6 音频系统..."

# Check if audio hardware is present
if [ ! -d "/sys/class/sound" ]; then
    echo "警告: 未检测到音频硬件"
    exit 0
fi

# Set audio parameters for OnePlus 6 (AQ3113 codec)
echo "设置音频参数..."

# Speaker volume
amixer -D pulse sset Master 80% 2>/dev/null || echo "音频控制跳过"

# Microphone gain
amixer -D pulse sset Capture 70% 2>/dev/null || echo "麦克风控制跳过"

# Enable audio services
systemctl start audio.service 2>/dev/null || echo "音频服务启动跳过"

echo "音频配置完成"
exit 0
