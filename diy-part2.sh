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

# =====================================================
# 0. 修改路由器默认后台 IP 为 10.1.1.1
# =====================================================
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate
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

