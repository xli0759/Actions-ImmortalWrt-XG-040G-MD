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
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)

echo ">>> 开始执行 DIY 脚本 <<<"

# =====================================================
# 1. 修改路由器默认 IP 为 10.1.1.1
# =====================================================
echo "1. 修改默认 IP..."
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# =====================================================
# 2. 清理官方 feeds 中自带的、可能冲突的 dae/daed 组件
# =====================================================
echo "2. 清理旧版 dae/daed 组件..."
rm -rf feeds/packages/net/dae*
rm -rf feeds/luci/applications/luci-app-dae*

# =====================================================
# 3. 拉取最新的 QiuSimons/luci-app-daed 源码
# =====================================================
echo "3. 拉取最新的 daed 源码..."
git clone https://github.com/QiuSimons/luci-app-daed package/dae

# =====================================================
# 4. 动态注入 daed 所需的 eBPF 及内核参数
# =====================================================
echo "4. 配置 eBPF 内核参数..."

# (1) 禁用 DEBUG_INFO_REDUCED（防止 eBPF 编译因缺少调试信息而失败）
# 先用 sed 删掉原有的配置，再显式声明不设置
sed -i '/CONFIG_KERNEL_DEBUG_INFO_REDUCED/d' .config
echo "# CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set" >> .config

# (2) 追加 eBPF 刚需选项及 daed 包配置
# 这些追加的配置会在随后的 make defconfig 环节自动被识别并处理依赖关系
cat >> .config <<EOF
# eBPF / BTF 环境要求
CONFIG_DEVEL=y
CONFIG_KERNEL_DEBUG_INFO=y
CONFIG_KERNEL_DEBUG_INFO_BTF=y
CONFIG_KERNEL_CGROUPS=y
CONFIG_KERNEL_CGROUP_BPF=y
CONFIG_KERNEL_BPF_EVENTS=y
CONFIG_BPF_TOOLCHAIN_HOST=y
CONFIG_KERNEL_XDP_SOCKETS=y

# 编译 daed 及其 LuCI 面板和依赖
CONFIG_PACKAGE_kmod-xdp-sockets-diag=y
CONFIG_PACKAGE_daed=y
CONFIG_PACKAGE_luci-app-daed=y
EOF

echo ">>> DIY 脚本执行完毕，daed 配置已注入 <<<"
