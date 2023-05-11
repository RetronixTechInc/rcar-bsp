#!/bin/sh

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

usage()
{
cat << EOF
    usage: `basename $0` source-directory

    Ex)
    `basename $0` my_package_dir
EOF
}

#### 2) Checking Arguments
if [ "X$1" = "X" ]; then
    usage
    exit 1
fi

while [ $# -gt 0 ] ; do
    case "$1" in
        *)
            _src_dirname=$(basename $1)
            _src_path=$(cd $(dirname $1) && pwd)
            _src_full=${_src_path}/${_src_dirname}
    esac
    shift
done

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

cd ${TMPWORK}

unzip ${_src_full}/RTM8RC0000ZNA2DS00JFAQE_1_0_18.zip
tar xvf ./RTM8RC0000ZNA2DS00JFAQE_1_0_18/RTM8RC0000ZNA2DS00JFAQE/Software/RTM8RC0000ZNA2DS00JFAQE.tar.gz

rm -rf ./RTM8RC0000ZNA2DS00JFAQE/kernel-source
mv RTM8RC0000ZNA2DS00JFAQE adsp-s492c
#patch -p 1 < ../hardware.renesas.s492c.diff

tar zcf adsp-s492c.tar.gz adsp-s492c
mv adsp-s492c.tar.gz ../../../modules/.
cd ..

rm -rf ${TMPWORK}

echo "done"
