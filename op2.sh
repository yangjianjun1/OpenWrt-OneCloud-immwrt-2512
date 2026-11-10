#!/bin/bash
# File name: diy-op2.sh

rm -rf package/chajian
mkdir -p package/chajian

# ====================== 第三方插件源码 ======================
# 关机插件
git clone --depth 1 --branch v2.7 https://github.com/sirpdboy/luci-app-poweroffdevice.git package/chajian/poweroffdevice

# luci-app-diskman 磁盘管理
rm -rf package/chajian/luci-app-diskman
git clone --depth 1 https://github.com/lisaac/luci-app-diskman.git package/chajian/luci-app-diskman
mkdir -p package/chajian/parted
wget -O package/chajian/parted/Makefile https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile

# ====================== IP / 主机名 / 时区 ======================
sed -i "s|set network\.lan\.ipaddr='192.168.1.1'|set network.lan.ipaddr='192.168.50.23'|g" package/base-files/files/bin/config_generate
sed -i "s|set system\.@system\[-1\]\.hostname='OpenWrt'|set system.@system[-1].hostname='OneCloud'|g" package/base-files/files/bin/config_generate
sed -i "s|set system\.@system\[-1\]\.timezone='UTC'|set system.@system[-1].timezone='CST-8'|g" package/base-files/files/bin/config_generate
sed -i "s|set system\.@system\[-1\]\.zonename='UTC'|set system.@system[-1].zonename='Asia/Shanghai'|g" package/base-files/files/bin/config_generate

# ====================== 主题 ======================
echo "CONFIG_PACKAGE_luci-theme-material=y" >> .config
sed -i '/CONFIG_PACKAGE_luci-theme-bootstrap/d' .config
echo "# CONFIG_PACKAGE_luci-theme-bootstrap is not set" >> .config
sed -i 's|option mediaurlbase.*|option mediaurlbase /luci-static/material|g' feeds/luci/modules/luci-base/root/etc/config/luci 2>/dev/null || true

# ====================== 固件名称 ======================
sed -i 's/NAME="%D"/NAME="OpenWrt"/g' package/base-files/files/usr/lib/os-release
sed -i 's/PRETTY_NAME="%D %V"/PRETTY_NAME="OpenWrt %V"/g' package/base-files/files/usr/lib/os-release
sed -i 's/OPENWRT_RELEASE="%D %V %C"/OPENWRT_RELEASE="OpenWrt %V %C"/g' package/base-files/files/usr/lib/os-release

# ====================== 晶晨打包脚本权限 ======================
chmod +x target/linux/amlogic/image/gen_aml_emmc_img.sh 2>/dev/null || true
chmod +x target/linux/amlogic/image/gen_aml_img.sh 2>/dev/null || true
chmod +x target/linux/amlogic/image/gen_aml_sdimg.sh 2>/dev/null || true
chmod +x target/linux/amlogic/image/gen_aml_update.sh 2>/dev/null || true

echo "✅ diy-op2.sh 执行完毕"
