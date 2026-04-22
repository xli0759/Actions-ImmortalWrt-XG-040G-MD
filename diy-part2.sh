#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#



# Description: OpenWrt DIY script part 2 (After Update feeds)

# 1. 移除极度臃肿的编程语言运行环境
echo "移除 Node.js 和 Perl..."
sed -i 's/CONFIG_NODEJS_22=y/# CONFIG_NODEJS_22 is not set/' .config
sed -i 's/CONFIG_PACKAGE_perl=y/# CONFIG_PACKAGE_perl is not set/' .config
sed -i '/perlbase-/d' .config
sed -i 's/CONFIG_ERLANG_JIT=y/# CONFIG_ERLANG_JIT is not set/' .config

# 2. 移除 Passwall 及所有无关的代理后端
echo "移除 Passwall 及其后端..."
sed -i '/CONFIG_PACKAGE_luci-app-passwall/d' .config
sed -i 's/CONFIG_PACKAGE_sing-box=y/# CONFIG_PACKAGE_sing-box is not set/' .config
sed -i 's/CONFIG_PACKAGE_haproxy=y/# CONFIG_PACKAGE_haproxy is not set/' .config
sed -i 's/CONFIG_PACKAGE_microsocks=y/# CONFIG_PACKAGE_microsocks is not set/' .config
sed -i 's/CONFIG_PACKAGE_dns2socks=y/# CONFIG_PACKAGE_dns2socks is not set/' .config
sed -i 's/CONFIG_PACKAGE_chinadns-ng=y/# CONFIG_PACKAGE_chinadns-ng is not set/' .config

# 3. 移除内网穿透、DDNS 等不必要的网络插件
echo "移除 Frpc, Zerotier, DDNS-GO 等..."
sed -i '/CONFIG_PACKAGE_luci-app-frpc/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-zerotier/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-ddns-go/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-natmap/d' .config

# 4. 移除 NAS、文件共享和磁盘管理工具
echo "移除 KSMBD, VSFTPD, Diskman, Rclone 等..."
sed -i '/CONFIG_PACKAGE_luci-app-ksmbd/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-vsftpd/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-diskman/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-rclone/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-hd-idle/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-vlmcsd/d' .config

# 5. 移除多余的系统工具
echo "移除 Watchcat, WOL 等..."
sed -i '/CONFIG_PACKAGE_luci-app-watchcat/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-wol/d' .config
sed -i 's/CONFIG_PACKAGE_wakeonlan=y/# CONFIG_PACKAGE_wakeonlan is not set/' .config
sed -i 's/CONFIG_PACKAGE_etherwake=y/# CONFIG_PACKAGE_etherwake is not set/' .config

# 6. 【核心】配置 eBPF 选项并启用官方自带的 daed
echo "处理 daed 及其内核依赖..."

# 关闭会导致 BTF 丢失的精简 debug info（非常关键，否则 daed 会被静默删除！）
sed -i 's/CONFIG_KERNEL_DEBUG_INFO_REDUCED=y/# CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set/' .config

cat >> .config <<EOF
# 开启内核 eBPF 及 BTF 支持 (daed 刚需)
CONFIG_DEVEL=y
CONFIG_BPF_TOOLCHAIN=y
CONFIG_KERNEL_BPF_EVENTS=y
CONFIG_KERNEL_CGROUP_BPF=y
CONFIG_KERNEL_DEBUG_INFO=y
CONFIG_KERNEL_DEBUG_INFO_BTF=y

# 启用 ImmortalWrt 官方源自带的 daed 及其面板
CONFIG_PACKAGE_daed=y
CONFIG_PACKAGE_luci-app-daed=y
CONFIG_PACKAGE_luci-i18n-daed-zh-cn=y
EOF
