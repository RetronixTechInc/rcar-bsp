#!/bin/bash
set hel adas $1

WORK=`pwd`
echo $WORK

git clone git://git.yoctoproject.org/poky
git clone git://git.openembedded.org/meta-openembedded
git clone https://github.com/renesas-rcar/meta-renesas.git

cd $WORK/poky
git checkout -b tmp 74b22db6879b388d700f61e08cb3f239cf940d18
cd $WORK/meta-openembedded
git checkout -b tmp 814eec96c2a29172da57a425a3609f8b6fcc6afe
cd $WORK/meta-renesas
git checkout -b tmp 89ca1415e3598789e9004363f9a38c1b3f41912d
git clone https://github.com/RetronixTechInc/meta-rtx-arm.git -b v4h-raptor/meta-rtx meta-rtx


# modify kernel recipe for sdk3p28
#KERNEL_BRANCH='"v4h-hel\/v5.10.147\/rcar-5.2.0.rc19"'
KERNEL_RECIPE="meta-rtx/recipes-kernel/linux/linux-renesas_5.10.bbappend"
KERNEL_URL_REL='"git:\/\/github.com\/RetronixTechInc\/rcar-kernel.git;protocol=https"'
KERNEL_URL_DEV='"git:\/\/git@github.com\/RetronixTechInc\/rcar-gen4-kernel.git;protocol=ssh"'

if [ "X$3" = "Xdevelop" ]; then
	sed "s/RTX_BSP_URL = .*/RTX_BSP_URL = ${KERNEL_URL_DEV}/g" -i ${KERNEL_RECIPE}
else
	sed "s/RTX_BSP_URL = .*/RTX_BSP_URL = ${KERNEL_URL_REL}/g" -i ${KERNEL_RECIPE}
fi


# modify uboot recipe for sdk3p28
#UBOOT_BRANCH='"v4h-hel\/v2022.01\/rcar-6.0.0.rc9"'
#UBOOT_RECIPE="meta-rtx/recipes-bsp/u-boot/u-boot_2022.01.bbappend"
#sed "s/RTX_BRANCH = .*/RTX_BRANCH = ${UBOOT_BRANCH}/g" -i ${UBOOT_RECIPE}


case "$1" in
"all" | "raptor" | "hel" | "grayhawk" | "whitehawk" | "eagle" | "condor")
	echo "Use build configuration for $1 board"
	;;
*)
	echo "Provide board name. Supported boards: raptor, hel, grayhawk, whitehawk, condor, eagle."
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

toolchain_function () {
	cd $WORK

	source $WORK/poky/oe-init-build-env build-$1-$2

	cp $WORK/meta-renesas/meta-rtx/docs/sample/conf/$1/$2/*.conf conf/

	echo "The build directory is $(pwd) "

	bitbake meta-toolchain
}

build_function () {
	cd $WORK

	source $WORK/poky/oe-init-build-env build-$1-$2

	cp $WORK/meta-renesas/meta-rtx/docs/sample/conf/$1/$2/*.conf conf/

	echo "The build directory is $(pwd) "

	if [ $2 = "bsp" ]; then
		echo "Run command: #bitbake rcar-image-minimal"
		bitbake rcar-image-minimal
	elif [ $2 = "adas" ]; then
		echo "Run command: #bitbake rcar-image-adas"
		bitbake rcar-image-adas
	fi
}

if [ "X$3" = "Xmeta-toolchain" ]; then
	toolchain_function $BOARD $OPTION $3
else
	build_function $BOARD $OPTION
fi
