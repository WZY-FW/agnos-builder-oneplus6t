name: Build Fajita Kernel

on:
  workflow_dispatch:
  push:
    branches: [oneplus6t, main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          submodules: recursive
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Install cross-compile toolchain
        run: |
          sudo apt-get update
          sudo apt-get install -y crossbuild-essential-arm64 gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu

      - name: Create symlink for toolchain
        run: |
          mkdir -p tools/aarch64-linux-gnu-gcc/bin
          ln -sf /usr/bin/aarch64-linux-gnu-gcc tools/aarch64-linux-gnu-gcc/bin/aarch64-linux-gnu-gcc
          ln -sf /usr/bin/aarch64-linux-gnu-ld tools/aarch64-linux-gnu-gcc/bin/aarch64-linux-gnu-ld.bfd

      - name: Build kernel
        run: |
          cd agnos-kernel-sdm845
          export ARCH=arm64
          export CROSS_COMPILE=aarch64-linux-gnu-
          make fajita_defconfig O=out
          make -j$(nproc) O=out
          cd ..

      - name: Package boot.img
        run: |
          mkdir -p output
          cp agnos-kernel-sdm845/out/arch/arm64/boot/Image.gz-dtb output/

          # Use mkbootimg from tools if available, otherwise skip
          if [ -f tools/mkbootimg ]; then
            tools/mkbootimg \
              --kernel output/Image.gz-dtb \
              --ramdisk /dev/null \
              --cmdline "console=ttyS0,115200n8 earlycon=msm_geni_serial,0xA840000 androidboot.hardware=qcom androidboot.console=ttyS0 video=DSI-1:1080x2340@60E ehci-hcd.park=3 lpm_levels.sleep_disabled=1 service_locator.enable=1 androidboot.selinux=permissive firmware_class.path=/lib/firmware/updates net.ifnames=0 dyndbg=\"\" " \
              --pagesize 4096 \
              --base 0x80000000 \
              --kernel_offset 0x8000 \
              --ramdisk_offset 0x8000 \
              --tags_offset 0x100 \
              --output output/boot.img
          fi

      - name: Upload boot.img artifact
        uses: actions/upload-artifact@v4
        with:
          name: boot-fajita
          path: output/boot.img
          retention-days: 30

      - name: Upload kernel modules artifact
        if: always()
        run: |
          mkdir -p modules
          cp agnos-kernel-sdm845/out/drivers/staging/qcacld-3.0/wlan.ko modules/ 2>/dev/null || true
          cp agnos-kernel-sdm845/out/techpack/audio/asoc/snd-soc-sdm845.ko modules/ 2>/dev/null || true
          cp agnos-kernel-sdm845/out/techpack/audio/asoc/codecs/snd-soc-wcd9xxx.ko modules/ 2>/dev/null || true
        continue-on-error: true

      - name: Upload modules artifact
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: kernel-modules-fajita
          path: modules/
          retention-days: 30
          continue-on-error: true
