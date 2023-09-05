#!/bin/bash

patch_des=${1}
git_clean=${2}
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
		if [ ! -d "${patch_des}/${2}" ]; then
			echo "Create fold ${patch_des}/${2}"
			mkdir -p "${patch_des}/${2}"
		fi
		
		cd "${patch_des}/${2}"
		if [[ ${patchs} == *.patch ]]; then
			echo "git am ${patchs}"
			if [ ! -d "${patch_des}/${2}/.git" ]; then
				echo "Create local git at ${patch_des}/${2}/.git"
				git init && git add . && git commit -a -m "create git."
			fi
			if [ "${git_clean}x" == "cleanx" ]; then
				rm -rf .git/rebase-apply
			fi
			git am "${patchs}"
		else
			echo "copy ${patchs} to ${patch_des}/${2}"
			cp "${patchs}" "${patch_des}/${2}/"
		fi
	fi
}

for patch in ${patch_all}; do
#~ echo "patch = ${patch}"
	if [ -d "${patch_path}/${patch}" ]; then
		patch_loop ${patch_path} "" ${patch}
	fi
done

