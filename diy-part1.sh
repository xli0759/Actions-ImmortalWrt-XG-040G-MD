#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
cat > target/linux/airoha/image/an7581.mk << 'EOF'
define Build/an7581-preloader
  cat $(STAGING_DIR_IMAGE)/an7581_$1-bl2.fip >> $@
endef

define Build/an7581-bl31-uboot
  cat $(STAGING_DIR_IMAGE)/an7581_$1-bl31-u-boot.fip >> $@
endef

define Device/FitImageLzma
	KERNEL_SUFFIX := -uImage.itb
	KERNEL = kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(DEVICE_DTS).dtb
	KERNEL_NAME := Image
endef

define Device/bell_xg-040g-md
  $(call Device/FitImageLzma)
  DEVICE_VENDOR := Nokia
  DEVICE_MODEL := Bell XG-040G-MD
  DEVICE_VARIANT := Router Mode
  DEVICE_DTS := an7581-bell_xg-040g-md
  SOC := an7581
  KERNEL_LOADADDR := 0x80088000
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  KERNEL_SIZE := 8192k
  IMAGE_SIZE := 261120k
  KERNEL_IN_UBI := 1
  UBINIZE_OPTS := -s 2048
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin := append-kernel | pad-to $$$$(KERNEL_SIZE) | append-ubi
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
  DEVICE_PACKAGES := kmod-phy-airoha-en8811h kmod-i2c-an7581 kmod-leds-gpio kmod-gpio-button-hotplug uboot-envtools ubi-utils kmod-usb-storage-uas blkid lsblk
endef
TARGET_DEVICES += bell_xg-040g-md
EOF
