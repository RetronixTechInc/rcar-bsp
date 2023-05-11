#/bin/bash

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

HAVE_ADSP=${HAVE_ADSP:="YES"}
HAVE_CMS=${HAVE_CMS:="NO"}
TOP=`pwd`
if [ $# -ne 1 ]; then
	echo "Usage: $ `basename $0` [H3|M3|M3N]" 1>&2
	exit 1
fi

TARGET=$1
if [ ${TARGET} = "H3" ] || [ ${TARGET} = "M3" ] || [ ${TARGET} = "M3N" ] || [ ${TARGET} = "ALL" ] ; then
	echo "TARGET="$TARGET
else
	echo "Invalid TARGET="$TARGET
	exit 1
fi

#
# extract pkgs_dir/gfx/*
#
extract_gfx()
{
	ls ${TOP}/pkgs_dir/gfx
	cd ${TOP}/pkgs_dir/gfx
		rm -fr RCH3G001A1001ZDO_1_0_3         || true
	#	rm -fr RCH3G002A1001ZNI_1_0_3         || true
		rm -fr INFRTM8RC7795ZGG00Q00JPAQE_1_0_3  || true
		rm -fr RCM3G001A1001ZDO_1_0_3         || true
	#	rm -fr RCM3G002A1001ZNI_1_0_3         || true
		rm -fr INFRTM8RC7796ZGG00Q00JPAQE_1_0_3  || true
		rm -fr RCN3G001A1001ZDO_1_0_3         || true
	#	rm -fr RCN3G002A1001ZNI_1_0_3         || true
		rm -fr INFRTM8RC7796ZGG00Q50JPAQE_1_0_3  || true

		if [ ${TARGET} = "H3" ] ; then
			extract_h3_gfx
		elif [ ${TARGET} = "M3" ] ; then
			extract_m3_gfx
		elif [ ${TARGET} = "M3N" ] ; then
			extract_m3n_gfx
		elif [ ${TARGET} = "ALL" ] ; then
			extract_h3_gfx
			extract_m3_gfx
			extract_m3n_gfx
		else
			echo "Invalid TARGET="$TARGET
		fi
	        cd ${TOP}/RELFILES/hardware/renesas/modules/
	        tar -zcvf gfx.tar.gz gfx
		rm -rf gfx
	        cd ${TOP}/RELFILES/hardware/renesas/proprietary/
	        tar -zcvf gfx.tar.gz gfx
		rm -rf gfx
	 cd ${TOP}
}
extract_h3_gfx()
{
	unzip RCH3G001A1001ZDO_1_0_3.zip
	tar -zxvf ${TOP}/pkgs_dir/gfx/RCH3G001A1001ZDO_1_0_3/RCH3G001A1001ZDO/gfx.tar.gz -C ${TOP}/RELFILES/hardware/renesas/modules
	unzip INFRTM8RC7795ZGG00Q00JPAQE_1_0_3.zip
	tar -zxvf ${TOP}/pkgs_dir/gfx/INFRTM8RC7795ZGG00Q00JPAQE_1_0_3/INFRTM8RC7795ZGG00Q00JPAQE/Software/INF_gfx.tar.gz -C ${TOP}/RELFILES/hardware/renesas/proprietary
}
extract_m3_gfx()
{
	unzip RCM3G001A1001ZDO_1_0_3.zip
	tar -zxvf ${TOP}/pkgs_dir/gfx/RCM3G001A1001ZDO_1_0_3/RCM3G001A1001ZDO/gfx.tar.gz -C ${TOP}/RELFILES/hardware/renesas/modules
	unzip INFRTM8RC7796ZGG00Q00JPAQE_1_0_3.zip
	tar -zxvf ${TOP}/pkgs_dir/gfx/INFRTM8RC7796ZGG00Q00JPAQE_1_0_3/INFRTM8RC7796ZGG00Q00JPAQE/Software/INF_gfx.tar.gz -C ${TOP}/RELFILES/hardware/renesas/proprietary
}
extract_m3n_gfx()
{
	unzip RCN3G001A1001ZDO_1_0_3.zip
	tar -zxvf ${TOP}/pkgs_dir/gfx/RCN3G001A1001ZDO_1_0_3/RCN3G001A1001ZDO/gfx.tar.gz -C ${TOP}/RELFILES/hardware/renesas/modules
	unzip INFRTM8RC7796ZGG00Q50JPAQE_1_0_3.zip
	tar -zxvf ${TOP}/pkgs_dir/gfx/INFRTM8RC7796ZGG00Q50JPAQE_1_0_3/INFRTM8RC7796ZGG00Q50JPAQE/Software/INF_gfx.tar.gz -C ${TOP}/RELFILES/hardware/renesas/proprietary
}

#
# extract pkgs_dir/omx/*
#
extract_omx()
{
	ls ${TOP}/pkgs_dir/omx

	cd RELFILES/hardware/renesas/proprietary/renesas-omx/
		./make_renesas-omx.sh              ${TOP}/pkgs_dir/omx 
		./make_hardware.renesas.uvcs_km.sh ${TOP}/pkgs_dir/omx
	cd ${TOP}
}
#
# extract pkgs_dir/adsp/*
#
extract_adsp()
{
	ls ${TOP}/pkgs_dir/adsp

	cd RELFILES/hardware/renesas/proprietary/renesas-adsp/
		./make_renesas-adsp.sh ${TOP}/pkgs_dir/adsp
		./make_hardware.renesas.s492c.sh ${TOP}/pkgs_dir/adsp
	cd ${TOP}
}
#
# extract pkgs_dir/cms/*
#
extract_cms()
{
	ls ${TOP}/pkgs_dir/cms
	cd RELFILES/hardware/renesas/proprietary/renesas-cms/
		./make_renesas-cms.sh ${TOP}/pkgs_dir/cms
	cd ${TOP}
}
#
# procedure
#
rm ${TOP}/RELFILES/hardware/renesas/modules/gfx.tar.gz     || true
rm ${TOP}/RELFILES/hardware/renesas/proprietary/gfx.tar.gz || true
extract_gfx

rm ${TOP}/RELFILES/hardware/renesas/propritary/omx.tar.gz  || true
rm ${TOP}/RELFILES/hardware/renesas/modules/uvcs.tar.gz || true
extract_omx

if [ ${HAVE_ADSP} = "YES" ]; then
	rm ${TOP}/RELFILES/hardware/renesas/proprietary/adsp.tar.gz  || true
	extract_adsp
fi

if [ ${HAVE_CMS} = "YES" ]; then
	rm ${TOP}/RELFILES/vendor/renesas/hal/cms.tar.gz	|| true
	extract_cms
fi

##exit

./buildenv.sh

##sed -i -e "s/USE_REFERENCE_OPTION=\"NO\"/USE_REFERENCE_OPTION=\"YES\"/" RELFILES/apply_patch.sh
cd RELFILES
	HAVE_ADSP=${HAVE_ADSP} HAVE_CMS=${HAVE_CMS} ./apply_patch.sh
cd ${TOP}
echo "Done : TARGET="$TARGET "HAVE_ADSP="${HAVE_ADSP} "HAVE_CMS="${HAVE_CMS}
