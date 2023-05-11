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

LIBRARY_VERSION=3_0_23

dist_lib64=./omx/prebuilts/lib64
dist_config=./omx/configs

usage()
{
cat << EOF
    usage: `basename $0`
    \$1: library directory
    \$2: "for_make_patch" or "for_make_source_code"

    Ex)
    `basename $0` \$WORK/pkgs_dir/omx for_make_patch
EOF
}

#### 2) Checking Arguments
if [ "X$1" = "X" ]; then
    usage
    exit 1
fi

if [ "$#" -ge 1 ]; then
	_src_dirname=$(basename $1)
        _src_path=$(cd $(dirname $1) && pwd)
        _src_full=${_src_path}/${_src_dirname}
fi

# source directory check
if [ ! -d ${_src_path}/${_src_dirname} ]; then
    echo "${_src_path}/${_src_dirname} not found."
    usage
    exit 1
fi

##### 3) create temp directory
TMPWORK=${PWD}/CP_SCRIPT_TEMP
if [ -d ${TMPWORK} ]; then
    echo "ERROR: Work directory already exist."
    exit 1
fi
install -d -m 700 ${TMPWORK}

tar xvf ./omx_skeleton.tar.gz -C ${TMPWORK}
cd ${TMPWORK}

LIBRARY_ZIP_NAME=(
    "RTM8RC0000ZMX0LQ00JPAQE"
    "RTM8RC0000ZMD4LQ00JPAQE"
    "RTM8RC0000ZMD1LQ00JPAQE"
    "RTM8RC0000ZME1LQ00JPAQE"
    "RTM8RC0000ZMDALQ00JPAQE"
    "RTM8RC0000ZMD0LQ00JPAQE"
    "RTM8RC0000ZME0LQ00JPAQE"
    "RTM8RC0000ZMD2LQ00JPAQE"
    "RTM8RC0000ZMD8LQ00JPAQE"
    "RTM8RC0000ZME8LQ00JPAQE"
    "RTM8RC0000ZMD9LQ00JPAQE"
)

for (( i = 0; i < ${#LIBRARY_ZIP_NAME[@]}; i++ ))
do
    if [ -e ${_src_full}/${LIBRARY_ZIP_NAME[i]}_${LIBRARY_VERSION}.zip ]; then
        unzip ${_src_full}/${LIBRARY_ZIP_NAME[i]}_${LIBRARY_VERSION}.zip
        tar xvf ./${LIBRARY_ZIP_NAME[i]}_${LIBRARY_VERSION}/${LIBRARY_ZIP_NAME[i]}/Software/${LIBRARY_ZIP_NAME[i]}.tar.bz2
        cp ./${LIBRARY_ZIP_NAME[i]}/lib64/*.so ${dist_lib64}
        cp ./${LIBRARY_ZIP_NAME[i]}/config/*.txt ${dist_config}
    fi
done

tar zcf omx.tar.gz omx
mv omx.tar.gz ../../../proprietary/.
cd ..

rm -rf ${TMPWORK}

echo "done"
