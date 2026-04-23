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

echo "开始精简固件并配置 daed..."

# =====================================================
# 1. 移除臃肿的编程语言运行环境
# =====================================================

# Node.js 22（CONFIG_NODEJS_22=y 存在于 .config）
sed -i 's/CONFIG_NODEJS_22=y/# CONFIG_NODEJS_22 is not set/' .config

# Perl 主包及其所有 perlbase- 子包
sed -i 's/CONFIG_PACKAGE_perl=y/# CONFIG_PACKAGE_perl is not set/' .config
sed -i '/^CONFIG_PACKAGE_perlbase-/s/=y/ is not set/' .config
sed -i '/^# CONFIG_PACKAGE_perlbase-/!{/perlbase-/d}' .config

# Erlang JIT（注意：.config 中 erlang 主包本身已是 not set，
# 只有 CONFIG_ERLANG_JIT=y 这一个孤立选项需要处理）
sed -i 's/CONFIG_ERLANG_JIT=y/# CONFIG_ERLANG_JIT is not set/' .config

# =====================================================
# 2. 移除 Passwall 及其关联后端
# =====================================================
sed -i '/^CONFIG_PACKAGE_luci-app-passwall/d' .config
sed -i '/^CONFIG_PACKAGE_luci-app-passwall_INCLUDE_/d' .config
sed -i 's/CONFIG_PACKAGE_sing-box=y/# CONFIG_PACKAGE_sing-box is not set/' .config
sed -i 's/CONFIG_PACKAGE_haproxy=y/# CONFIG_PACKAGE_haproxy is not set/' .config
sed -i 's/CONFIG_PACKAGE_microsocks=y/# CONFIG_PACKAGE_microsocks is not set/' .config
sed -i 's/CONFIG_PACKAGE_dns2socks=y/# CONFIG_PACKAGE_dns2socks is not set/' .config
sed -i 's/CONFIG_PACKAGE_chinadns-ng=y/# CONFIG_PACKAGE_chinadns-ng is not set/' .config
# passwall 翻译包一并清理
sed -i '/^CONFIG_PACKAGE_luci-i18n-passwall/d' .config
# ipt2socks 是 passwall 依赖
sed -i 's/CONFIG_PACKAGE_ipt2socks=y/# CONFIG_PACKAGE_ipt2socks is not set/' .config

# =====================================================
# 3. 移除内网穿透、DDNS 等无关网络应用
# =====================================================
# frpc（luci-app + 后端二进制 + 翻译包）
sed -i '/^CONFIG_PACKAGE_luci-app-frpc/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-frpc/d' .config
sed -i 's/CONFIG_PACKAGE_frpc=y/# CONFIG_PACKAGE_frpc is not set/' .config

# zerotier
sed -i '/^CONFIG_PACKAGE_luci-app-zerotier/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-zerotier/d' .config
sed -i 's/CONFIG_PACKAGE_zerotier=y/# CONFIG_PACKAGE_zerotier is not set/' .config
sed -i '/^# CONFIG_ZEROTIER_/d' .config

# ddns-go
sed -i '/^CONFIG_PACKAGE_luci-app-ddns-go/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-ddns-go/d' .config
sed -i 's/CONFIG_PACKAGE_ddns-go=y/# CONFIG_PACKAGE_ddns-go is not set/' .config

# natmap
sed -i '/^CONFIG_PACKAGE_luci-app-natmap/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-natmap/d' .config
sed -i 's/CONFIG_PACKAGE_natmap=y/# CONFIG_PACKAGE_natmap is not set/' .config

# =====================================================
# 4. 移除文件共享、磁盘管理等工具
# =====================================================
# ksmbd（luci + 内核模块 + 后端服务）
sed -i '/^CONFIG_PACKAGE_luci-app-ksmbd/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-ksmbd/d' .config
sed -i 's/CONFIG_PACKAGE_kmod-fs-ksmbd=y/# CONFIG_PACKAGE_kmod-fs-ksmbd is not set/' .config
sed -i 's/CONFIG_PACKAGE_ksmbd-server=y/# CONFIG_PACKAGE_ksmbd-server is not set/' .config
sed -i 's/CONFIG_PACKAGE_wsdd2=y/# CONFIG_PACKAGE_wsdd2 is not set/' .config

# vsftpd
sed -i '/^CONFIG_PACKAGE_luci-app-vsftpd/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-vsftpd/d' .config
sed -i 's/CONFIG_PACKAGE_vsftpd=y/# CONFIG_PACKAGE_vsftpd is not set/' .config

# diskman（luci + lsblk + btrfs-progs 等通过 diskman 选项拉入的）
sed -i '/^CONFIG_PACKAGE_luci-app-diskman/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-diskman/d' .config

# rclone（luci 插件，后端 rclone 本身 .config 里是 not set，无需额外处理）
sed -i '/^CONFIG_PACKAGE_luci-app-rclone/d' .config

# hd-idle
sed -i '/^CONFIG_PACKAGE_luci-app-hd-idle/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-hd-idle/d' .config
sed -i 's/CONFIG_PACKAGE_hd-idle=y/# CONFIG_PACKAGE_hd-idle is not set/' .config

# vlmcsd（KMS 激活服务，路由器不需要）
sed -i '/^CONFIG_PACKAGE_luci-app-vlmcsd/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-vlmcsd/d' .config
sed -i 's/CONFIG_PACKAGE_vlmcsd=y/# CONFIG_PACKAGE_vlmcsd is not set/' .config

# =====================================================
# 5. 移除多余的系统工具类 App
# =====================================================
# watchcat
sed -i '/^CONFIG_PACKAGE_luci-app-watchcat/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-watchcat/d' .config
sed -i 's/CONFIG_PACKAGE_watchcat=y/# CONFIG_PACKAGE_watchcat is not set/' .config

# wol（网络唤醒）
sed -i '/^CONFIG_PACKAGE_luci-app-wol/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-wol/d' .config
sed -i 's/CONFIG_PACKAGE_wakeonlan=y/# CONFIG_PACKAGE_wakeonlan is not set/' .config
sed -i 's/CONFIG_PACKAGE_etherwake=y/# CONFIG_PACKAGE_etherwake is not set/' .config

# =====================================================
# 针对 QiuSimons/luci-app-daed 的核心处理逻辑
# =====================================================

# 6. 安装前端构建工具 pnpm（官方 README 要求，编译面板需要）
npm install -g pnpm

# 7. 清理官方 feeds 中旧的或冲突的 dae/daed 组件
rm -rf feeds/packages/net/dae
rm -rf feeds/packages/net/daed
rm -rf feeds/luci/applications/luci-app-dae
rm -rf feeds/luci/applications/luci-app-daed

# 8. 获取 QiuSimons 的 luci-app-daed 源码
# 官方 README 明确指定克隆到 package/dae，保持原样
git clone https://github.com/QiuSimons/luci-app-daed package/dae
git clone https://github.com/QiuSimons/vmlinux-btf package/vmlinux-btf

# 9. 修改内核参数以满足 DAE 的要求

# (1) 禁用 DEBUG_INFO_REDUCED（.config 中存在 =y，需要改为 not set）
#     官方文档要求设为 n，OpenWrt .config 语法中 =n 无效，
#     正确做法是先删除再追加 not set 注释
sed -i '/CONFIG_KERNEL_DEBUG_INFO_REDUCED/d' .config
echo "# CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set" >> .config

# (2) 追加全部必需的内核与包配置
#     .config 中已有：CONFIG_KERNEL_DEBUG_INFO=y / CONFIG_KERNEL_CGROUPS=y /
#     CONFIG_KERNEL_CGROUP_BPF=y，追加不会冲突（后出现的值生效）
cat >> .config <<EOF
# 内核 eBPF / BTF 刚需选项（daed 要求）
CONFIG_DEVEL=y
CONFIG_KERNEL_DEBUG_INFO=y
CONFIG_KERNEL_DEBUG_INFO_BTF=y
CONFIG_KERNEL_CGROUPS=y
CONFIG_KERNEL_CGROUP_BPF=y
CONFIG_KERNEL_BPF_EVENTS=y
CONFIG_BPF_TOOLCHAIN_HOST=y
CONFIG_KERNEL_XDP_SOCKETS=y
CONFIG_PACKAGE_kmod-xdp-sockets-diag=y
# 编译 daed 核心、vmlinux-btf 外部 BTF 包与 LuCI 控制面板
CONFIG_PACKAGE_vmlinux-btf=y
CONFIG_PACKAGE_daed=y
CONFIG_PACKAGE_luci-app-daed=y
CONFIG_PACKAGE_luci-i18n-daed-zh-cn=y
EOF

echo "精简与 daed 配置完成！"
