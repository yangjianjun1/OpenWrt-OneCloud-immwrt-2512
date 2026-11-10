#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-op3.sh
# Description: OpenWrt DIY script part3 (After compile, clean zero file & unused feeds)
#
set -e

# ========== 编译前feed清理（原有功能保留） ==========
sed -i '/src-git freifunk/d' feeds.conf.default
sed -i '/src-git video/d' feeds.conf.default
sed -i '/src-git oldpackages/d' feeds.conf.default
sed -i '/src-git targets/d' feeds.conf.default
echo "✅ 已清理不需要的 feeds"
cat feeds.conf.default

# ========== 编译完成后：删除bin目录下所有0字节空文件，修复gh-release 422报错 ==========
BIN_DIR="./openwrt/bin/targets/amlogic/meson8b"
if [ -d "$BIN_DIR" ];then
    echo "🧹 扫描并删除0字节空文件: $BIN_DIR"
    find "$BIN_DIR" -type f -size 0 -delete
    echo "✅ 空文件清理完成"
fi
