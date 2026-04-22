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


#!/bin/bash
# Description: OpenWrt DIY script part 2 (After Update feeds)

echo "开始精简固件并配置 daed..."

# 1. 移除极度臃肿的编程语言运行环境 (路由器不需要这些)
sed -i 's/CONFIG_NODEJS_22=y/# CONFIG_NODEJS_22 is not set/' .config
sed -i 's/CONFIG_PACKAGE_perl=y/# CONFIG_PACKAGE_perl is not set/' .config
sed -i '/perlbase-/d' .config
sed -i 's/CONFIG_ERLANG_JIT=y/# CONFIG_ERLANG_JIT is not set/' .config

# 2. 移除 Passwall 及其关联后端
sed -i '/CONFIG_PACKAGE_luci-app-passwall/d' .config
sed -i 's/CONFIG_PACKAGE_sing-box=y/# CONFIG_PACKAGE_sing-box is not set/' .config
sed -i 's/CONFIG_PACKAGE_haproxy=y/# CONFIG_PACKAGE_haproxy is not set/' .config
sed -i 's/CONFIG_PACKAGE_microsocks=y/# CONFIG_PACKAGE_microsocks is not set/' .config
sed -i 's/CONFIG_PACKAGE_dns2socks=y/# CONFIG_PACKAGE_dns2socks is not set/' .config
sed -i 's/CONFIG_PACKAGE_chinadns-ng=y/# CONFIG_PACKAGE_chinadns-ng is not set/' .config

# 3. 移除内网穿透、DDNS 等无关网络应用
sed -i '/CONFIG_PACKAGE_luci-app-frpc/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-zerotier/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-ddns-go/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-natmap/d' .config

# 4. 移除文件共享、磁盘管理等工具
sed -i '/CONFIG_PACKAGE_luci-app-ksmbd/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-vsftpd/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-diskman/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-rclone/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-hd-idle/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-vlmcsd/d' .config

# 5. 移除多余的系统工具类 App
sed -i '/CONFIG_PACKAGE_luci-app-watchcat/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-wol/d' .config
sed -i 's/CONFIG_PACKAGE_wakeonlan=y/# CONFIG_PACKAGE_wakeonlan is not set/' .config
sed -i 's/CONFIG_PACKAGE_etherwake=y/# CONFIG_PACKAGE_etherwake is not set/' .config

# =======================================================
# 下面是专门针对 QiuSimons/luci-app-daed 的核心处理逻辑
# =======================================================

# 6. 为 GitHub Actions 主机安装前端构建工具 pnpm (编译面板需要)
sudo npm install -g pnpm

# 7. 清理官方旧的或冲突的 dae/daed 组件
rm -rf feeds/packages/net/dae
rm -rf feeds/packages/net/daed
rm -rf feeds/luci/applications/luci-app-dae
rm -rf feeds/luci/applications/luci-app-daed

# 8. 获取 QiuSimons 的 luci-app-daed 源码
git clone https://github.com/QiuSimons/luci-app-daed package/dae

# 9. 强制修改内核参数，使其满足 DAE 的苛刻要求
# (1) 关闭精简版 DEBUG_INFO（非常重要，不关会导致 BTF 缺失）
sed -i 's/CONFIG_KERNEL_DEBUG_INFO_REDUCED=y/# CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set/' .config

# (2) 写入必需的依赖项
cat >> .config <<EOF
# 内核 eBPF / BTF 刚需选项
CONFIG_DEVEL=y
CONFIG_KERNEL_DEBUG_INFO=y
CONFIG_KERNEL_DEBUG_INFO_BTF=y
CONFIG_KERNEL_CGROUPS=y
CONFIG_KERNEL_CGROUP_BPF=y
CONFIG_KERNEL_BPF_EVENTS=y
CONFIG_BPF_TOOLCHAIN_HOST=y
CONFIG_KERNEL_XDP_SOCKETS=y
CONFIG_PACKAGE_kmod-xdp-sockets-diag=y

# 编译 daed 核心与 LuCI 控制面板
CONFIG_PACKAGE_daed=y
CONFIG_PACKAGE_luci-app-daed=y
CONFIG_PACKAGE_luci-i18n-daed-zh-cn=y
EOF

echo "精简与 daed 配置完成！"
