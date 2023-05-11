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
DATE=`date +"%Y%m%d_%H%M%S"`
REPO_OPTION="-j8 -c"

VERSION=10.0.0_r40
ANDROID_VERSION=android-${VERSION}
MYDROID_DIR=mydroid

REPO_URL_MIRROR=https://android.googlesource.com/mirror/manifest
REPO_URL_DIRECT=https://android.googlesource.com/platform/manifest

UPDATE_MIRROR="NO"
UPDATE_MIRROR_BY_SUDO="NO"
USE_MIRROR="NO"
LOCAL_MIRROR_DIR=${TOP}/aosp_mirror
#
# update AOSP mirror
#
update_aosp_mirror()
{
	cd ${TOP}

	${SUDO} ls
	${SUDO} mkdir ${LOCAL_MIRROR_DIR} 2> /dev/null
	if [ $? -eq 0 ] ; then
		cd ${LOCAL_MIRROR_DIR} \
		&& ${SUDO} repo init -u ${REPO_URL_MIRROR} --mirror \
		|| exit 1
	else
		cd ${LOCAL_MIRROR_DIR} \
		|| exit 1
	fi
	${SUDO} repo sync ${REPO_OPTION} \
	&& cd .. \
	|| exit 1

	cd ${TOP}
}


#
# get AOSP specfic version (from the mirror)
#
get_aosp()
{
	cd ${TOP}

	if [ -e ${MYDROID_DIR} ] ; then
		echo "remove ${TOP}/${MYDROID_DIR} directory."
		exit 1
	fi
	mkdir ${MYDROID_DIR} 2> /dev/null

	cd ${MYDROID_DIR} \
	|| exit 1

		repo init -u ${URL} -b ${ANDROID_VERSION} \
		&& repo sync ${REPO_OPTION} \
		|| exit 1

	cd ..
	cd ${TOP}
}

if [ ${UPDATE_MIRROR} = "YES" ] ; then
	if [ ${UPDATE_MIRROR_BY_SUDO} = "YES" ] ; then
		SUDO=sudo
	fi
	update_aosp_mirror
fi

if [ ${USE_MIRROR} = "YES" ] ; then
	URL=${LOCAL_MIRROR_DIR}/platform/manifest.git
else
	URL=${REPO_URL_DIRECT}
fi
get_aosp

echo
echo "Done"
echo
