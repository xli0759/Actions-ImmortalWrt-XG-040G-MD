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
sed -i '/define Device\/airoha_an7581-evb-emmc-eagle/,/^endef/d' target/linux/airoha/image/an7581.mk
sed -i '/TARGET_DEVICES += airoha_an7581-evb-emmc-eagle/d' target/linux/airoha/image/an7581.mk
sed -i '/define Device\/airoha_an7581-evb-emmc-kite/,/^endef/d' target/linux/airoha/image/an7581.mk
sed -i '/TARGET_DEVICES += airoha_an7581-evb-emmc-kite/d' target/linux/airoha/image/an7581.mk
