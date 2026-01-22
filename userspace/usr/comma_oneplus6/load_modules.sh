#!/bin/bash -e
# oneplus6_modules.sh - Load OnePlus 6 specific kernel modules for AGNOS

echo "加载 OnePlus 6 (enchilada) 内核模块..."

# Audio modules
echo "加载音频模块..."
insmod /usr/comma/snd-soc-sdm845.ko 2>/dev/null || echo "音频模块加载跳过 (可能已内置)"
insmod /usr/comma/snd-soc-wcd9xxx.ko 2>/dev/null || echo "Codec模块加载跳过 (可能已内置)"

# WiFi module
echo "加载WiFi模块..."
insmod /usr/comma/wlan.ko 2>/dev/null || echo "WiFi模块加载跳过 (可能已内置)"

# Touchscreen (if available)
if [ -f "/usr/comma/synaptics_dsx.ko" ]; then
    echo "加载触屏模块..."
    insmod /usr/comma/synaptics_dsx.ko
fi

# Display (if available)
if [ -f "/usr/comma/mdss_dsi.ko" ]; then
    echo "加载显示模块..."
    insmod /usr/comma/mdss_dsi.ko
fi

# Camera (if available)
if [ -f "/usr/comma/camera_qcom2.ko" ]; then
    echo "加载摄像头模块..."
    insmod /usr/comma/camera_qcom2.ko
fi

# GPS (if available)
if [ -f "/usr/comma/qcom_gps.ko" ]; then
    echo "加载GPS模块..."
    insmod /usr/comma/qcom_gps.ko
fi

echo "内核模块加载完成"
exit 0
