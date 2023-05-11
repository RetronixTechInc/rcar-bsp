#!/bin/bash

#
# Copyright (C) Renesas Electronics Corporation 2017-2019 All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

set -eu

TOP=`pwd`

ABSPV=v10_2.0p3
VERSION=10.0.0_r40
WORK=${TOP}/../mydroid/
USE_REFERENCE_OPTION="NO"
DATE=`date +"%Y%m%d_%H%M%S"`

HAVE_ADSP=${HAVE_ADSP:="YES"}
HAVE_CMS=${HAVE_CMS:="NO"}

source ./target_dir.sh

if [ ${USE_REFERENCE_OPTION} = "NO" ] ; then
	REFERENCE_IPL=""
	REFERENCE_OPTEE=""
	REFERENCE_UBOOT=""
	REFERENCE_KERNEL=""
else
	REFERENCE_IPL="--reference /home/git/arm-trusted-firmware.git/"
	REFERENCE_OPTEE="--reference /home/git/optee_os.git/"
	REFERENCE_UBOOT="--reference /home/git/u-boot.git/"
	REFERENCE_KERNEL="--reference /home/git/linux.git/"
fi

ls ${WORK} || exit

#
# hardware/renesas/hal
#
# |-- hardware/renesas/hal
# |   |-- hardware.renesas.*.tar.gz
#
hardware_renesas_hal()
{
echo && echo "hardware/renesas/hal:"
cd ${WORK}
	mkdir -p hardware/renesas/hal
	cd hardware/renesas/hal
		echo && pwd
		for td in ${added_dir_hardware_renesas_hal[@]}; do
			td_name=`echo ${td} | sed -e 's/hardware\/renesas\/hal\///g' -e 's/\///g'`
			tar zxvf ${TOP}/hardware/renesas/hal/${td_name}.tar.gz
		done
cd ${WORK}
}

#
# hardware/renesas/modules
#
# |-- hardware/renesas/modules
# |   |-- hardware.renesas.*.tar.gz
#
hardware_renesas_modules()
{
echo && echo "hardware/renesas/modules:"
cd ${WORK}
	rm -rf hardware/renesas/modules
	mkdir -p hardware/renesas/modules
	cd hardware/renesas/modules
		echo && pwd
		for td in ${added_dir_hardware_renesas_modules[@]}; do
			td_name=`echo ${td} | sed -e 's/hardware\/renesas\/modules\///g' -e 's/\///g'`
			if [ X${td_name} == "Xgfx" ]; then
				tar zxvf ${TOP}/hardware/renesas/modules/gfx.tar.gz
			elif [ X${td_name} == "Xadsp-s492c" ]; then
				if [ X${HAVE_ADSP} = "XYES" ]; then
					tar zxvf ${TOP}/hardware/renesas/modules/adsp-s492c.tar.gz
				fi
			else
				tar zxvf ${TOP}/hardware/renesas/modules/${td_name}.tar.gz
			fi
		done
cd ${WORK}
}

#
# hardware/renesas/proprietary
#
# |-- hardware/renesas/proprietary
# |   |-- hardware.renesas.*.tar.gz
#
hardware_renesas_proprietary()
{
echo && echo "hardware/renesas/proprietary:"
cd ${WORK}
	rm -rf hardware/renesas/proprietary
	mkdir -p hardware/renesas/proprietary
	cd hardware/renesas/proprietary
		echo && pwd
		for td in ${added_dir_hardware_renesas_proprietary[@]}; do
			td_name=`echo ${td} | sed -e 's/hardware\/renesas\/proprietary\///g' -e 's/\///g'`
			if [ X${td_name} == "Xgfx" ]; then
				tar zxvf ${TOP}/hardware/renesas/proprietary/gfx.tar.gz
				tar zxvf ${TOP}/hardware/renesas/proprietary/gfx_prebuilts_common.tar.gz
			elif [ X${td_name} == "Xadsp" ]; then
				if [ X${HAVE_ADSP} = "XYES" ]; then
					tar zxvf ${TOP}/hardware/renesas/proprietary/adsp.tar.gz
				fi
			else
				tar zxvf ${TOP}/hardware/renesas/proprietary/${td_name}.tar.gz
			fi
		done
cd ${WORK}
}

#
# hardware/realtek
#
# |-- hardware/realtek
# |   |-- .*.tar.gz
#
hardware_realtek()
{
echo && echo "hardware/realtek:"
cd ${WORK}
	mkdir -p hardware/realtek
	cd hardware/realtek
		echo && pwd
		for td in ${added_dir_hardware_realtek[@]}; do
			td_name=`echo ${td} | sed -e 's/hardware\/realtek\///g' -e 's/\///g'`
			tar zxvf ${TOP}/hardware/realtek/${td_name}.tar.gz
		done
cd ${WORK}
}

#
# hardware/ti
#
# |-- hardware/ti
# |   |-- .*.tar.gz
#
hardware_ti()
{
echo && echo "hardware/ti:"
cd ${WORK}
	mkdir -p hardware/ti
	cd hardware/ti
		echo && pwd
		for td in ${added_dir_hardware_ti[@]}; do
			td_name=`echo ${td} | sed -e 's/hardware\/ti\///g' -e 's/\///g'`
			tar zxvf ${TOP}/hardware/ti/${td_name}.tar.gz
		done
cd ${WORK}
}
#
# vendor/renesas/apps
#
# |-- vendor/renesas/apps
# |   |-- vendor.renesas.*.tar.gz
#
vendor_renesas_apps()
{
echo && echo "vendor/renesas/apps:"
cd ${WORK}
	mkdir -p vendor/renesas/apps
	cd vendor/renesas/apps
		echo && pwd
		for td in ${added_dir_vendor_renesas_apps[@]}; do
			td_name=`echo ${td} | sed -e 's/vendor\/renesas\/apps\///g' -e 's/\///g'`
				tar zxvf ${TOP}/vendor/renesas/apps/${td_name}.tar.gz
		done
cd ${WORK}
}

#
# vendor/renesas/hal
#
# |-- vendor/renesas/hal
# |   |-- vendor.renesas.*.tar.gz
#
vendor_renesas_hal()
{
echo && echo "vendor/renesas/hal:"
cd ${WORK}
	mkdir -p vendor/renesas/hal
	cd vendor/renesas/hal
		echo && pwd
		for td in ${added_dir_vendor_renesas_hal[@]}; do
			td_name=`echo ${td} | sed -e 's/vendor\/renesas\/hal\///g' -e 's/\///g'`
			if [ X${td_name} == "Xcms" ]; then
				if [ X${HAVE_CMS} = "XYES" ]; then
					tar zxvf ${TOP}/vendor/renesas/hal/cms.tar.gz
				fi
			else
				tar zxvf ${TOP}/vendor/renesas/hal/${td_name}.tar.gz
			fi
		done
cd ${WORK}
}

#
# vendor/renesas/hardware
#
# |-- vendor/renesas/hardware
# |   |-- vendor.renesas.*.tar.gz
#
vendor_renesas_hardware()
{
echo && echo "vendor/renesas/hardware:"
cd ${WORK}
	mkdir -p vendor/renesas/hardware
	cd vendor/renesas/hardware
		echo && pwd
		for td in ${added_dir_vendor_renesas_hardware[@]}; do
			td_name=`echo ${td} | sed -e 's/vendor\/renesas\/hardware\///g' -e 's/\///g'`
			tar zxvf ${TOP}/vendor/renesas/hardware/${td_name}.tar.gz
		done
cd ${WORK}
}
vendor_renesas_firmware()
{
echo && echo "vendor/renesas/firmware:"
cd ${WORK}
        mkdir -p vendor/renesas/firmware
        cd vendor/renesas/firmware
                echo && pwd
                for td in ${added_dir_vendor_renesas_firmware[@]}; do
                        td_name=`echo ${td} | sed -e 's/vendor\/renesas\/firmware\///g' -e 's/\///g'`
                        tar zxvf ${TOP}/vendor/renesas/firmware/${td_name}.tar.gz
                done
cd ${WORK}
}
#
# vendor/renesas/utils
#
# |-- vendor/renesas/utils
# |   |-- vendor.renesas.*.tar.gz
#
vendor_renesas_utils()
{
echo && echo "vendor/renesas/utils:"
cd ${WORK}
	mkdir -p vendor/renesas/utils
	cd vendor/renesas/utils
		echo && pwd
		for td in ${added_dir_vendor_renesas_utils[@]}; do
			td_name=`echo ${td} | sed -e 's/vendor\/renesas\/utils\///g' -e 's/\///g'`
			tar zxvf ${TOP}/vendor/renesas/utils/${td_name}.tar.gz
		done
cd ${WORK}
}

#
# device/renesas
#
# |-- device/renesas
# |   |-- *.tar.gz
#
device_renesas()
{
echo && echo "device/renesas:"
cd ${WORK}
	mkdir -p device/renesas
	cd device/renesas
		echo && pwd
		for td in ${added_dir_device_renesas[@]}; do
			td_name=`echo ${td} | sed -e 's/device\/renesas\///g' -e 's/\///g'`
			tar zxvf ${TOP}/device/renesas/${td_name}.tar.gz
		done
cd ${WORK}
}

#
# device/renesas/bootloaders/
#
# |-- bootloaders
# |   |-- ipl.*.bundle
# |   |-- optee.*.bundle
# |   `-- u-boot.*.bundle
#
device_renesas_bootloaders()
{
echo && echo "IPL"
cd ${WORK}
	mkdir -p device/renesas/bootloaders
	cd device/renesas/bootloaders
		echo && pwd
		git clone https://github.com/renesas-rcar/arm-trusted-firmware.git ipl ${REFERENCE_IPL}
		cd ipl
			git remote update
			git status
			git bundle unbundle ${TOP}/device/renesas/bootloaders/ipl.${ABSPV}.bundle
			git checkout fe8e917a9c29c67bab4a7ec6ccfdfb91435f8bb1

cd ${WORK}

echo && echo "optee"
cd ${WORK}
	mkdir -p device/renesas/bootloaders
	cd device/renesas/bootloaders
		echo && pwd
		git clone https://github.com/renesas-rcar/optee_os.git optee ${REFERENCE_OPTEE}
		cd optee
			git remote update
			git status
			git bundle unbundle ${TOP}/device/renesas/bootloaders/optee.${ABSPV}.bundle
			git checkout 1e795a3ec4376fbf7f4068cc1ac95a46c667bcd7

cd ${WORK}

echo && echo "U-Boot"
cd ${WORK}
	mkdir -p device/renesas/bootloaders
	cd device/renesas/bootloaders
		echo && pwd
		git clone https://github.com/renesas-rcar/u-boot.git u-boot ${REFERENCE_UBOOT}
		cd u-boot
			git remote update
			git status
			git bundle unbundle ${TOP}/device/renesas/bootloaders/u-boot.${ABSPV}.bundle
			git checkout 1a9044feca0ff04e015e66532d238bf75115ef7b

cd ${WORK}
}

#
# device/renesas/kernel
#
# |-- kernel
# |   `-- kernel.*.bundle
#
device_renesas_kernel()
{
echo && echo "Kernel:"
cd ${WORK}
	mkdir -p device/renesas
	cd device/renesas
		echo && pwd
		git clone https://github.com/renesas-rcar/linux-bsp.git kernel ${REFERENCE_KERNEL}
		cd kernel
			git remote add android https://android.googlesource.com/kernel/common
			git remote update
			git status

			git bundle unbundle ${TOP}/device/renesas/kernel.${ABSPV}.bundle
                        git checkout a6f09052214c86c4cc613d3add93fa6cf5ecd752
cd ${WORK}
}

#
# device/renesas/linux-firmware
#
linux-firmware()
{
echo && echo "Linux-firmware:"
cd ${WORK}
	mkdir -p device/renesas
	cd device/renesas
		echo && pwd
		wget https://launchpad.net/ubuntu/+archive/primary/+files/linux-firmware_1.127.20.tar.gz
		tar zxvf linux-firmware_1.127.20.tar.gz
#		mkdir -p salvator-kernel/firmware/rtlwifi/
#		cp linux-firmware/rtlwifi/rtl8188eufw.bin salvator-kernel/firmware/rtlwifi/
#		cp linux-firmware/rtlwifi/rtl8192cufw.bin salvator-kernel/firmware/rtlwifi/
cd ${WORK}
}

#
# prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu
#  aarch64-linux-gnu-gcc (Linaro GCC 7.3-2018.05) 7.3.1 20180425
#
# |-- aarch64-linux-gnu
# |   `-- Android.mk
#
aarch64-linux-gnu()
{
echo && echo "aarch64-linux-gnu:"
cd ${WORK}
	cd prebuilts/gcc/linux-x86/aarch64/
		wget https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
		xz -vd   gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
		tar -xvf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar
		mv gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu aarch64-linux-gnu
		cp ${TOP}/aarch64-linux-gnu/Android.mk aarch64-linux-gnu/Android.mk
cd ${WORK}
}

#
# patch for AOSP
#
# |-- aosp_patches
# |   |-- bionic
# ..
#
apply_aosp_patch()
{
PATCH=${TOP}/aosp_patches
echo && echo "Patch:"
cd ${WORK}
	for td in ${changed_dir[@]}; do
		cd ${td}
			echo && echo && pwd
			git checkout android-${VERSION}
			ls -asl ${PATCH}/${td}/*
			git am ${PATCH}/${td}/*
		cd ${WORK}
	done
cd ${WORK}
}

#delete_unnecessary()
#{
#echo && echo "Unnecessary:"
#cd ${WORK}
#	for td in ${removed_dir[@]}; do
#		rm -fr ${td}
#	done
#cd ${WORK}
#}

hardware_renesas_hal
hardware_renesas_modules
hardware_renesas_proprietary
hardware_realtek
hardware_ti
vendor_renesas_apps
vendor_renesas_hal
vendor_renesas_hardware
vendor_renesas_firmware
vendor_renesas_utils
device_renesas
device_renesas_bootloaders
device_renesas_kernel

#linux-firmware
aarch64-linux-gnu
apply_aosp_patch
#delete_unnecessary

echo
echo "Done"
echo
