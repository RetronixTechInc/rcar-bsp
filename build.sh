#!/bin/bash

SCRIPT_DIR=$(cd `dirname $0` && pwd)
BOARD_LIST=("h3salvator" "m3salvator")
DRAM_SIZE_LIST=("4GB" "8GB")
TARGET_BOARD="h3salvator"
DRAM_SIZE="8GB"
WORKDIRECTORY=${TARGET_BOARD}
IMAGE_DIR_NAME="images_${TARGET_BOARD}"

Usage () {
    echo "Usage: $0 \${TARGET_BOARD_NAME} (DRAM_SIZE:h3salvator_only_option)"
    echo "BOARD_NAME list: "
    for i in ${BOARD_LIST[@]}; do echo "  - $i"; done
    echo "H3 only: DRAM_SIZE list"
    for i in ${DRAM_SIZE_LIST[@]}; do echo "  - $i"; done
    exit
}

# Check Param.
if ! `IFS=$'\n'; echo "${BOARD_LIST[*]}" | grep -qx "${TARGET_BOARD}"`; then
    Usage
fi
if [[ "${TARGET_BOARD}" == "h3salvator" ]]; then
    if ! `IFS=$'\n'; echo "${DRAM_SIZE_LIST[*]}" | grep -qx "${DRAM_SIZE}"`; then
        Usage
    fi
    WORKDIRECTORY+="_${DRAM_SIZE}"
    IMAGE_DIR_NAME+="_${DRAM_SIZE}"
fi

if [ -d ${SCRIPT_DIR}/${WORKDIRECTORY} ]; then
echo "source code exist!"
export workdirectory=${SCRIPT_DIR}/${WORKDIRECTORY}
cd ${workdirectory}/work/mydroid

else

mkdir -p ${SCRIPT_DIR}/${WORKDIRECTORY}
cd ${SCRIPT_DIR}/${WORKDIRECTORY}
export workdirectory=$(pwd)
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ./repo
chmod +x ./repo
export PATH=$(pwd):${PATH}

#~ cp ${SCRIPT_DIR}/Gen3_Android_v10_2.0.zip -t ${workdirectory}
#~ cd ${workdirectory}
#~ unzip -qo Gen3_Android_v10_2.0.zip
#~ unzip -qo OSS_Package/Gen3_Android_v10_2.0.zip -d OSS_Package
#~ unzip -qo Software/SV00_Android_10_2.0.zip -d Software
#~ unzip -qo OSS_Package/Gen3_Android_v10_2.0/RENESAS_RCH3M3M3N_Android_10_ReleaseNote_2020_09E.zip

#~ cp -r ${workdirectory}/Software/proprietary/pkgs_dir .
#~ mv RENESAS_RCH3M3M3N_Android_10_ReleaseNote_2020_09E work


cp -r ${SCRIPT_DIR}/retronix-tools/work ${workdirectory}/
cd ${workdirectory}/work 

export workspace=$(pwd)

cd ${workspace}
chmod +x walkthrough.sh
./walkthrough.sh $(echo ${TARGET_BOARD} | sed 's/salvator//' | tr '[:lower:]' '[:upper:]')

#~ patch IVI PCBA.
path_file=${SCRIPT_DIR}/patch/patch.sh
if [ -f ${path_file} ] && [ -x ${path_file} ]; then
${path_file} "${workdirectory}/work/mydroid"
fi

cd ${workspace}/mydroid
fi

if [[ "${TARGET_BOARD}" == "h3salvator" ]]; then
    export TARGET_BOARD_PLATFORM=r8a7795
    export H3_OPTION=${DRAM_SIZE}
elif [[ "${TARGET_BOARD}" == "m3salvator" ]]; then
    export TARGET_BOARD_PLATFORM=r8a7796
fi

# Please set Android build environment
source build/envsetup.sh

# Salvator case
lunch salvator-userdebug

# Please set these variables to true.
export BUILD_BOOTLOADERS=true
export BUILD_BOOTLOADERS_SREC=true

NUM_JOBS=$(($(grep ^processor /proc/cpuinfo | wc -l)*2))
echo "NUM_JOBS=${NUM_JOBS}"

#~ make unpack_bootimg 2>&1 | tee build.log
#~ make lpunpack 2>&1 | tee build.log
#~ make -j${NUM_JOBS} 2>&1 | tee build-`date +%s`.log
make -j${NUM_JOBS} 2>&1 | tee build.log

export board_name=salvator
#~ export images_dir=/home/tom/temp/rcar/3_IVI/Image/IVI-16G-Android10
export images_dir=${workdirectory}/../IVI-16G-Android10
if [ ! -d ${images_dir} ]; then
mkdir -p ${images_dir}
fi
cp -f \
    out/target/product/${board_name}/boot.img \
    out/target/product/${board_name}/dtb.img \
    out/target/product/${board_name}/dtbo.img \
    out/target/product/${board_name}/vbmeta.img \
    out/target/product/${board_name}/system.img \
    out/target/product/${board_name}/vendor.img \
    out/target/product/${board_name}/product.img \
    out/target/product/${board_name}/bootloader.img \
    out/target/product/${board_name}/odm.img \
    out/target/product/${board_name}/ramdisk.img \
    out/target/product/${board_name}/ramdisk-debug.img \
    out/target/product/${board_name}/boot-debug.img \
    out/target/product/${board_name}/super.img \
    out/target/product/${board_name}/super_empty.img \
    out/target/product/${board_name}/bl2.srec \
    out/target/product/${board_name}/bl31.srec \
    out/target/product/${board_name}/bootparam_sa0.srec \
    out/target/product/${board_name}/cert_header_sa6.srec \
    out/target/product/${board_name}/tee.srec \
    out/target/product/${board_name}/u-boot-elf.srec \
    out/target/product/${board_name}/bl2.bin \
    vendor/renesas/utils/fastboot/fastboot.sh \
    vendor/renesas/utils/fastboot/fastboot_functions.sh \
    out/host/linux-x86/bin/adb \
    out/host/linux-x86/bin/mke2fs \
    out/host/linux-x86/bin/fastboot \
    ${SCRIPT_DIR}/retronix-tools/AArch64_Gen3_H3_M3_Scif_MiniMon_V5.13.mot \
    ${SCRIPT_DIR}/retronix-tools/write.sh ${images_dir}

