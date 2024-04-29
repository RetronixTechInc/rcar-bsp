#!/bin/bash

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
git checkout -b tmp 42ba4a6d45d5479200b6baf7d9cbffb4d1a0d7f5
git clone https://github.com/RetronixTechInc/rcar-bsp.git -b v4h-raptor/meta-rtx meta-rtx


case "$1" in
"all" | "whitehawk" | "eagle" | "condor")
    echo "Use build configuration for $1 board"
    ;;
*)
    echo "Provide board name. Supported boards: whitehawk, condor, eagle."
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
GFX_FILE_PATH=$3

# Copy GFX package to build layer
copy_gfx_package () {
cd ${WORK}
cp ${GFX_FILE_PATH}/gfxdrv/GSX_KM_V4H.tar.bz2 ${WORK}/meta-renesas/meta-rcar-adas/recipes-kernel/kernel-module-gles/kernel-module-gles/
cp ${GFX_FILE_PATH}/opengl/r8a779g0_linux_gsx_binaries_gles.tar.bz2 ${WORK}/meta-renesas/meta-rcar-adas/recipes-graphics/gles-user-module/gles-user-module/
}

build_function () {
cd $WORK

source $WORK/poky/oe-init-build-env build-$1-$2

cp $WORK/meta-rtx/docs/sample/conf/$1/$2/*.conf conf/

echo "The build directory is $(pwd) "

if [ $2 = "bsp" ]; then
    echo "Run command: #bitbake rcar-image-minimal"
    bitbake rcar-image-minimal
elif [ $2 = "adas" ]; then
    if [ $1 = "whitehawk" ]; then
        if [[ "${GFX_FILE_PATH}" != "" ]]; then
            sed -i 's|#MACHINE_FEATURES_append = " gsx"|MACHINE_FEATURES_append = " gsx"|g' conf/local.conf
        fi

    fi
    echo "Run command: #bitbake rcar-image-adas"
    bitbake rcar-image-adas
fi
}
# Copy GFX package if build ADAS and boards include whitehawk
if [ $OPTION = "adas" ]; then
    if [ $BOARD = "whitehawk" ] || [ $BOARD = "all" ]; then
        if [[ "${GFX_FILE_PATH}" != "" ]]; then
            copy_gfx_package
        fi
    fi
fi

if [ $BOARD = "all" ]; then
    build_function whitehawk $OPTION
    build_function condor $OPTION
else
    build_function $BOARD $OPTION
fi
