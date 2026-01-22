# OnePlus 6 AGNOS 移植状态报告

## 移植概述

| 项目 | 状态 | 说明 |
|------|------|------|
| 设备 | OnePlus 6 (enchilada) | 基于sdm845芯片组 |
| 芯片组 | Qualcomm Snapdragon 845 (sdm845) | 与Pixel 3相同芯片组 |
| AGNOS版本 | 5.1 | 基于Ubuntu 20.04 |
| 构建系统 | Docker | 基于Docker的构建流程 |
| 内核 | 一加6官方内核 | 使用enchilada_defconfig |

## 已完成工作

### ✅ 基础架构
- 创建一加6专有配置目录结构
- 更新Dockerfile.agnos支持一加6
- 修复QEMU注册问题
- 优化构建流程

### ✅ 固件提取与集成
- 从安卓9系统分区备份提取固件
- 从官方 OnePlus 6 固件包提取 DSP、Modem、Venus 固件
- 整理固件目录结构 (firmware_oneplus6/)
- 集成所有必需固件到 system.img
- 创建固件清单文档

### ✅ 固件完整性验证
- GPU 固件 (Adreno A630): a630_gmu.bin, a630_sqe.fw, a630_zap.* ✓
- 摄像头固件: CAMERA_ICP.elf ✓
- IPA 固件: ipa_fws.b00-b04, ipa_fws.elf, ipa_fws.mdt ✓
- Widevine DRM 固件: widevine.b00-b07, widevine.mdt ✓
- DSP 固件:
  - ADSP (24个文件): 音频解码器、语音处理模块 ✓
  - CDSP (17个文件): 计算DSP、视频后处理 ✓
  - SDSP (21个文件): 传感器DSP、CHRE框架 ✓
- Venus 视频编解码固件: venus.b00-b04, venus.mdt ✓
- WiFi 固件: wlanmdsp.mbn (QCA6174) ✓

### ✅ 配置文件
- 创建一加6 fstab分区配置
- 创建weston显示服务配置
- 创建USB模式配置脚本
- 创建内核模块加载脚本

### ✅ 构建脚本
- build_kernel.sh 使用 enchilada_defconfig
- build_system.sh 修复QEMU问题
- flash_all.sh 简化为单分区版本
- README.md 更新为一加6构建指南

### ✅ 目录结构
```
userspace/firmware_oneplus6/    # 一加6专有固件
userspace/files_oneplus6/       # 一加6设备配置
userspace/usr/comma_oneplus6/   # 一加6特定脚本和模块
```

## 硬件支持状态

| 硬件 | 状态 | 说明 |
|------|------|------|
| CPU | ✅ 支持 | sdm845，与Pixel 3相同 |
| GPU | ✅ 支持 | Adreno 630，固件已集成 |
| 存储 | ✅ 支持 | 单分区方案 |
| 网络 | ✅ 固件就绪 | WiFi固件已集成，待实际测试 |
| 音频 | ✅ 固件就绪 | DSP固件已集成，待实际测试 |
| 摄像头 | ⏳ 开发中 | 相机固件已提取，camera_qcom2待适配 |
| 传感器 | ✅ 固件就绪 | SDSP固件已集成，待实际测试 |
| 触摸屏 | ⏳ 开发中 | 待测试 |
| 视频编解码 | ✅ 固件就绪 | Venus固件已集成，待实际测试 |
| DRM | ✅ 固件就绪 | Widevine DRM固件已集成，待实际测试 |

## 构建状态

| 构建步骤 | 状态 | 说明 |
|----------|------|------|
| 内核构建 | ✅ 完成 | 使用enchilada_defconfig |
| 系统构建 | ✅ 完成 | Docker构建流程，所有固件已集成 |
| 镜像生成 | ✅ 完成 | 生成system.img (2.8GB) 和boot.img |
| 固件集成 | ✅ 完成 | GPU/DSP/Venus/WiFi/DRM固件全部集成 |
| 刷机脚本 | ✅ 完成 | 支持单分区刷写 |

## 待解决的问题

### 高优先级
- [ ] 摄像头驱动适配 (camera_qcom2 需要支持 IMX519 传感器)
- [ ] WiFi 功能实际测试 (固件已集成)
- [ ] 音频功能实际测试 (DSP固件已集成)

## 刷机前准备

### ⚠️ 分区调整要求

**重要**: OnePlus 6 默认的 system 分区只有 2.8GB，而 AGNOS system.img 约 2.7GB，几乎占满整个分区。为了确保系统正常运行并有足够空间安装额外软件，**必须先调整分区大小**。

#### 原始分区布局

| 分区名称 | 设备路径 | 大小 |
|---------|---------|------|
| system_a | /dev/sda13 | 2.8 GiB |
| system_b | /dev/sda14 | 2.8 GiB |
| userdata | /dev/sda17 | 110 GiB |

#### 调整后分区布局

| 分区名称 | 设备路径 | 大小 | 变化 |
|---------|---------|------|------|
| system_a | /dev/sda13 | 15 GiB | 2.8GB → 15GB (+12.2GB) |
| system_b | /dev/sda14 | 15 GiB | 2.8GB → 15GB (+12.2GB) |
| userdata | /dev/sda17 | 85 GiB | 110GB → 85GB (-25GB) |

#### 分区调整步骤

1. 下载 TWRP for OnePlus 6: [下载链接](https://dl.twrp.me/enchilada/)
2. 启动到 TWRP: `fastboot boot twrp-3.3.1-0-enchilada.img`
3. 在 TWRP 终端中执行分区调整命令
4. 格式化新分区
5. 重启到 Fastboot 模式继续刷机

详细步骤请参考 [刷机指南.md](./刷机指南.md)

### 中优先级
- [ ] 触摸屏功能测试
- [ ] 视频编解码功能测试 (Venus固件已集成)
- [ ] 传感器驱动配置 (SDSP固件已集成)
- [ ] OpenPilot 完整适配
- [ ] 性能优化

### 低优先级
- [ ] 功耗优化
- [ ] 高级功能支持

## 后续计划

### 近期计划
1. 完成摄像头驱动适配
2. 测试WiFi和音频功能
3. 优化系统启动时间
4. 完善OpenPilot适配

### 远期计划
1. 支持所有硬件功能
2. 优化性能和稳定性
3. 支持更多OpenPilot功能
4. 提供预构建镜像

## 构建与测试

### 构建命令
```bash
# 构建内核
./build_kernel.sh

# 构建系统
./build_system.sh

# 刷写设备
./flash_all.sh
```

### 测试步骤
1. 构建镜像
2. 刷入设备
3. 检查启动状态
4. 测试硬件功能
5. 运行OpenPilot

## 贡献指南

### 提交代码
1. Fork仓库
2. 创建特性分支
3. 提交变更
4. 创建Pull Request

### 报告问题
- 使用GitHub Issues
- 提供详细的错误信息
- 包含测试环境信息

### 测试反馈
- 提供设备型号和系统版本
- 描述复现步骤
- 提供日志信息

## 资源链接

- [AGNOS移植计划文档](../.trae/documents/AGNOS移植计划：从Pixel%203到一加6.md)
- [安卓9系统分区备份](../oneplus6_安卓9_系统分区备份/)
- [OpenPilot适配代码](../openpilot_oneplus6/)
- [一加6内核源码](../android_kernel_oneplus_sdm845/)
- [设备树源码](../android_device_oneplus_enchilada/)

## 团队

| 角色 | 负责人 | 联系方式 |
|------|--------|----------|
| 项目负责人 | - | - |
| 内核开发 | - | - |
| 系统集成 | - | - |
| 测试 | - | - |

## 许可证

参考原始AGNOS项目许可证。

## 更新日志

### 2026-01-21
- 完成基础架构移植
- 提取并整理固件
- 更新构建脚本
- 创建文档

### 后续更新
- 持续更新移植状态
- 记录测试结果
- 跟踪问题解决情况
