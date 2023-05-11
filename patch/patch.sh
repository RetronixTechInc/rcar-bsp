#!/bin/bash

patch_des=${1}
patch_path=$(cd `dirname $0` && pwd)
patch_all=`ls ${patch_path}`
patchs=""

function patch_loop
{
	path="${1}/${2}"
	#~ echo "path = ${path}"
	patchs="${path}/${3}"
	#~ echo "patchs = ${patchs}"
	if [ -d ${patchs} ]; then
		patch_files=`ls ${patchs}`
		local patch_fd=${2}/${3}
		#~ echo "patch_fd = ${patch_fd}"
		for patch in ${patch_files}; do
			patch_loop ${patch_path} ${patch_fd} ${patch}
		done
	else
		if [[ ${patchs} == *.patch ]]; then
			#~ echo "cd ${patch_des}/${2}"
			echo "git am ${patchs}"
			
			cd "${patch_des}/${2}"
			git am "${patchs}"
		fi
	fi
}

for patch in ${patch_all}; do
#~ echo "patch = ${patch}"
	if [ -d "${patch_path}/${patch}" ]; then
		patch_loop ${patch_path} "" ${patch}
	fi
done
