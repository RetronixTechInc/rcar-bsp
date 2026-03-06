#!/bin/bash
set raptor adas

#DEF_DOWNLOADS_FOLD='/home/tom/data2/source-code/yocto/downloads'

WORK=`pwd`
echo $WORK

git clone git://git.yoctoproject.org/poky
git clone git://git.openembedded.org/meta-openembedded
git clone https://github.com/renesas-rcar/meta-renesas.git

cd $WORK/poky
git checkout -b tmp fb91a49387cfb0c8d48303bb3354325ba2a05587
cd $WORK/meta-openembedded
git checkout -b tmp a72010b414ee3d73888ac9cb4e310e8f05e13aea
cd $WORK/meta-renesas
git checkout -b tmp 88ba6f8a032cbd1df1f659b7e0cd3fda2e09bb03
git clone https://github.com/RetronixTechInc/meta-rtx-arm.git -b v4h-raptor/meta-rtx-scarthgap meta-rtx

MACHINE_CONF="meta-rtx/conf/machine/$1.conf"

# modify kernel recipe for sdk3p40
KERNEL_BRANCH='"v4h-raptor\/v5.10.235\/rcar-5.2.2.rc2"'
KERNEL_URL_REL='"git:\/\/github.com\/RetronixTechInc\/rcar-kernel.git;protocol=https"'
KERNEL_URL_DEV='"git:\/\/git@github.com\/RetronixTechInc\/rcar-gen4-kernel.git;protocol=ssh"'

sed "s/RTX_BSP_BRANCH = .*/RTX_BSP_BRANCH = ${KERNEL_BRANCH}/g" -i ${MACHINE_CONF}
if [ "$3" = "develop" ]; then
	sed "s/RTX_KERNEL_URL = .*/RTX_KERNEL_URL = ${KERNEL_URL_DEV}/g" -i ${MACHINE_CONF}
else
	sed "s/RTX_KERNEL_URL = .*/RTX_KERNEL_URL = ${KERNEL_URL_REL}/g" -i ${MACHINE_CONF}
fi

# modify uboot recipe for sdk3p40
UBOOT_BRANCH='"v4h-raptor\/v2022.01\/rcar-6.0.0.rc13"'
sed "s/RTX_UBOOT_BRANCH = .*/RTX_UBOOT_BRANCH = ${UBOOT_BRANCH}/g" -i ${MACHINE_CONF}

case "$1" in
"all" | "raptor")
    echo "Use build configuration for $1 board"
    ;;
*)
    echo "Provide board name. Supported boards: raptor."
    exit -1
    ;;
esac

case "$2" in
"bsp" | "adas")
    echo "Use build option $2 for $1 board"
    ;;
*)
    echo "Provide build option. Supported option: bsp, adas."
    exit -1
    ;;
esac

BOARD=$1
OPTION=$2

build_function () {
cd $WORK

source $WORK/poky/oe-init-build-env build-$1-$2

cp $WORK/meta-renesas/meta-rtx/docs/sample/conf/$1/$2/*.conf conf/
if [ -d "${DEF_DOWNLOADS_FOLD}" ] ; then
    if [ -L downloads ]; then
        rm downloads
    fi
    ln -s ${DEF_DOWNLOADS_FOLD} downloads
fi

echo "The build directory is $(pwd) "

if [ $2 = "bsp" ]; then
    echo "Run command: #bitbake rcar-image-minimal"
    bitbake rcar-image-minimal
elif [ $2 = "adas" ]; then
    echo "Run command: #bitbake rcar-image-adas"
    bitbake rcar-image-adas
fi
}

if [ $BOARD = "all" ]; then
    build_function raptor $OPTION
else
    build_function $BOARD $OPTION
fi
