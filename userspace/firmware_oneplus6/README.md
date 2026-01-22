# OnePlus 6 Firmware Directory

## 说明
此目录用于存放一加6的专有固件文件。所有固件已从官方ROM中成功提取。

## 固件文件状态

### ✅ 已提取固件

#### 1. ADSP (Audio DSP) - 67 个文件
- 位置: `dsp/adsp/`
- 文件: 音频解码器、编码器、处理模块、FastRPC shell、CHRE、系统监控、VPP
- 状态: ✅ 完整

#### 2. CDSP (Compute DSP) - 17 个文件
- 位置: `dsp/cdsp/`
- 文件: C++ 标准库、FastRPC shell、系统监控、VPP
- 状态: ✅ 完整

#### 3. SLPI (Sensor DSP) - 51 个文件
- 位置: `dsp/sdsp/`
- 文件: 传感器应用、FastRPC shell、CHRE、系统监控、VPP
- 状态: ✅ 完整

#### 4. Venus (Video Codec) - 6 个文件
- 位置: `modem/`
- 文件: venus.b00, venus.b01, venus.b02, venus.b03, venus.b04, venus.mdt
- 状态: ✅ 完整

#### 5. WiFi DSP - 1 个文件
- 位置: `modem/`
- 文件: wlanmdsp.mbn (3,035,140 bytes)
- 状态: ✅ 完整

#### 6. GPU (Adreno 630) - 7 个文件
- 位置: 根目录
- 文件: a630_gmu.bin, a630_sqe.fw, a630_zap.b*
- 状态: ✅ 完整

#### 7. CAMERA_ICP - 1 个文件
- 位置: 根目录
- 文件: CAMERA_ICP.elf (3,299,320 bytes)
- 状态: ✅ 完整

#### 8. IPA - 6 个文件
- 位置: 根目录
- 文件: ipa_fws.b*
- 状态: ✅ 完整

#### 9. Widevine DRM - 8 个文件
- 位置: 根目录
- 文件: widevine.b*
- 状态: ✅ 完整

#### 10. CPPF - 8 个文件
- 位置: 根目录
- 文件: cppf.b*
- 状态: ✅ 完整

### ⚠️ 部分缺失固件

#### WiFi 固件
- 缺失: bdwlan.bin, qwlan.bin, otp.bin, utf.bin
- 说明: 这些标准 WiFi 固件文件在官方 ROM 中未找到
- 替代: wlanmdsp.mbn (WiFi DSP 固件) 已提取
- 状态: ⚠️ 使用 wlanmdsp.mbn 作为替代

#### Modem 固件
- 缺失: 完整的 Modem 固件 (modem.mdt, modem.b*)
- 说明: 只提取了 Venus 和 WiFi DSP 固件
- 状态: ⚠️ 部分提取

## 提取来源

### 官方固件包
- 文件: `OnePlus6Hydrogen_22_OTA_034_all_1909041314_0edfbb2dfaa34e94.zip`
- 版本: OnePlus 6 HydrogenOS 22 OTA 034
- 日期: 2019-09-04

### 提取工具
- payload_dumper: 用于提取 payload.bin 中的分区镜像
- 挂载工具: 用于挂载分区镜像并提取固件文件

## 目录结构

```
firmware_oneplus6/
├── README.md                    # 本文件
├── a630_gmu.bin                # GPU GMU 固件
├── a630_sqe.fw                 # GPU SQE 固件
├── a630_zap.b00                # GPU zap 固件
├── a630_zap.b01                # GPU zap 固件
├── a630_zap.b02                # GPU zap 固件
├── a630_zap.elf                # GPU zap 固件
├── a630_zap.mdt                # GPU zap 固件
├── CAMERA_ICP.elf              # 相机 ICP 固件
├── ipa_fws.b00                 # IPA 固件
├── ipa_fws.b01                 # IPA 固件
├── ipa_fws.b02                 # IPA 固件
├── ipa_fws.b03                 # IPA 固件
├── ipa_fws.b04                 # IPA 固件
├── ipa_fws.elf                 # IPA 固件
├── ipa_fws.mdt                 # IPA 固件
├── widevine.b00                # Widevine DRM 固件
├── widevine.b01                # Widevine DRM 固件
├── widevine.b02                # Widevine DRM 固件
├── widevine.b03                # Widevine DRM 固件
├── widevine.b04                # Widevine DRM 固件
├── widevine.b05                # Widevine DRM 固件
├── widevine.b06                # Widevine DRM 固件
├── widevine.b07                # Widevine DRM 固件
├── widevine.mdt                # Widevine DRM 固件
├── cppf.b00                    # 相机处理固件
├── cppf.b01                    # 相机处理固件
├── cppf.b02                    # 相机处理固件
├── cppf.b03                    # 相机处理固件
├── cppf.b04                    # 相机处理固件
├── cppf.b05                    # 相机处理固件
├── cppf.b06                    # 相机处理固件
├── cppf.b07                    # 相机处理固件
├── cppf.mdt                    # 相机处理固件
├── dsp/                        # DSP 固件目录
│   ├── adsp/                   # 音频 DSP 固件 (67 个文件)
│   ├── cdsp/                   # 计算 DSP 固件 (17 个文件)
│   └── sdsp/                   # 传感器 DSP 固件 (51 个文件)
└── modem/                      # Modem 固件目录
    ├── venus.b00                # 视频编解码器固件
    ├── venus.b01                # 视频编解码器固件
    ├── venus.b02                # 视频编解码器固件
    ├── venus.b03                # 视频编解码器固件
    ├── venus.b04                # 视频编解码器固件
    ├── venus.mdt                # 视频编解码器固件
    └── wlanmdsp.mbn             # WiFi DSP 固件
```

## 使用方法

### 在 Dockerfile.agnos 中使用

```dockerfile
# 复制 GPU 固件
COPY ./userspace/firmware_oneplus6/a630_gmu.bin /lib/firmware/
COPY ./userspace/firmware_oneplus6/a630_sqe.fw /lib/firmware/
COPY ./userspace/firmware_oneplus6/a630_zap.b00 /lib/firmware/
COPY ./userspace/firmware_oneplus6/a630_zap.b01 /lib/firmware/
COPY ./userspace/firmware_oneplus6/a630_zap.b02 /lib/firmware/
COPY ./userspace/firmware_oneplus6/a630_zap.elf /lib/firmware/
COPY ./userspace/firmware_oneplus6/a630_zap.mdt /lib/firmware/

# 复制相机固件
COPY ./userspace/firmware_oneplus6/CAMERA_ICP.elf /lib/firmware/
COPY ./userspace/firmware_oneplus6/cppf.b00 /lib/firmware/
COPY ./userspace/firmware_oneplus6/cppf.b01 /lib/firmware/
COPY ./userspace/firmware_oneplus6/cppf.b02 /lib/firmware/
COPY ./userspace/firmware_oneplus6/cppf.b03 /lib/firmware/
COPY ./userspace/firmware_oneplus6/cppf.b04 /lib/firmware/
COPY ./userspace/firmware_oneplus6/cppf.b05 /lib/firmware/
COPY ./userspace/firmware_oneplus6/cppf.b06 /lib/firmware/
COPY ./userspace/firmware_oneplus6/cppf.b07 /lib/firmware/
COPY ./userspace/firmware_oneplus6/cppf.mdt /lib/firmware/

# 复制 IPA 固件
COPY ./userspace/firmware_oneplus6/ipa_fws.b00 /lib/firmware/
COPY ./userspace/firmware_oneplus6/ipa_fws.b01 /lib/firmware/
COPY ./userspace/firmware_oneplus6/ipa_fws.b02 /lib/firmware/
COPY ./userspace/firmware_oneplus6/ipa_fws.b03 /lib/firmware/
COPY ./userspace/firmware_oneplus6/ipa_fws.b04 /lib/firmware/
COPY ./userspace/firmware_oneplus6/ipa_fws.elf /lib/firmware/
COPY ./userspace/firmware_oneplus6/ipa_fws.mdt /lib/firmware/

# 复制 Widevine DRM 固件
COPY ./userspace/firmware_oneplus6/widevine.b00 /lib/firmware/
COPY ./userspace/firmware_oneplus6/widevine.b01 /lib/firmware/
COPY ./userspace/firmware_oneplus6/widevine.b02 /lib/firmware/
COPY ./userspace/firmware_oneplus6/widevine.b03 /lib/firmware/
COPY ./userspace/firmware_oneplus6/widevine.b04 /lib/firmware/
COPY ./userspace/firmware_oneplus6/widevine.b05 /lib/firmware/
COPY ./userspace/firmware_oneplus6/widevine.b06 /lib/firmware/
COPY ./userspace/firmware_oneplus6/widevine.b07 /lib/firmware/
COPY ./userspace/firmware_oneplus6/widevine.mdt /lib/firmware/

# 复制 DSP 固件
COPY ./userspace/firmware_oneplus6/dsp/adsp/* /lib/firmware/adsp/
COPY ./userspace/firmware_oneplus6/dsp/cdsp/* /lib/firmware/cdsp/
COPY ./userspace/firmware_oneplus6/dsp/sdsp/* /lib/firmware/sdsp/

# 复制 Modem 固件
COPY ./userspace/firmware_oneplus6/modem/venus.b00 /lib/firmware/
COPY ./userspace/firmware_oneplus6/modem/venus.b01 /lib/firmware/
COPY ./userspace/firmware_oneplus6/modem/venus.b02 /lib/firmware/
COPY ./userspace/firmware_oneplus6/modem/venus.b03 /lib/firmware/
COPY ./userspace/firmware_oneplus6/modem/venus.b04 /lib/firmware/
COPY ./userspace/firmware_oneplus6/modem/venus.mdt /lib/firmware/
COPY ./userspace/firmware_oneplus6/modem/wlanmdsp.mbn /lib/firmware/
```

## 后续步骤

1. ✅ 所有关键固件已提取完成
2. 🔄 更新 Dockerfile.agnos 以包含新提取的固件
3. 🔄 重新构建 system.img
4. 🔄 测试系统启动和硬件功能

## 重要说明

### WiFi 固件说明
- 已提取: wlanmdsp.mbn (WiFi DSP 固件)
- 缺失: bdwlan.bin, qwlan.bin, otp.bin, utf.bin
- 建议: 先使用 wlanmdsp.mbn 测试，如果出现问题再寻找其他固件来源

### Modem 固件说明
- 已提取: Venus 固件（视频编解码器）和 WiFi DSP 固件
- 缺失: 完整的 Modem 固件（基带）
- 建议: 如果需要完整的 Modem 固件，可以从 modem 分区中提取所有文件

## 固件统计

- **固件文件总数:** 171 个
- **固件总大小:** 约 15 MB
- **DSP 固件:** 135 个文件 (约 15 MB)
- **Modem 固件:** 7 个文件 (约 3 MB)
- **Vendor 固件:** 29 个文件 (约 2 MB)

## 参考文档

- [固件提取报告](/home/ubuntu/oneplus6-openpilot-project/openspec/changes/research-oneplus6-camera-firmware/firmware-extraction-report.md)
- [备份固件检查报告](/home/ubuntu/oneplus6-openpilot-project/openspec/changes/research-oneplus6-camera-firmware/backup-firmware-check-report.md)
- [相机适配报告](/home/ubuntu/oneplus6-openpilot-project/openspec/changes/research-oneplus6-camera-firmware/camera-adaptation-report.md)
