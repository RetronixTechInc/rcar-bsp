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

added_dir_device_renesas=(
	# except for "kernel" & "bootloader"
	"device/renesas/salvator"
	"device/renesas/kingfisher"
	"device/renesas/common"
)
added_dir_hardware_realtek=(
	"hardware/realtek/wlan"
)
added_dir_hardware_renesas_hal=(
	"hardware/renesas/hal/allocator"
	"hardware/renesas/hal/fastboot"
	"hardware/renesas/hal/gatekeeper"
	"hardware/renesas/hal/hwcomposer"
	"hardware/renesas/hal/keymaster"
	"hardware/renesas/hal/mapper"
	"hardware/renesas/hal/oemlock"
)
added_dir_hardware_renesas_modules=(
	"hardware/renesas/modules/adsp-s492c"
	"hardware/renesas/modules/avb-mch"
	"hardware/renesas/modules/avb-mse"
	"hardware/renesas/modules/avb-streaming"
	"hardware/renesas/modules/gfx"
	"hardware/renesas/modules/mmngr"
	"hardware/renesas/modules/qos"
	"hardware/renesas/modules/uvcs"
	"hardware/renesas/modules/vspm"
	"hardware/renesas/modules/vspmif"
)
added_dir_hardware_renesas_proprietary=(
	"hardware/renesas/proprietary/adsp"
	"hardware/renesas/proprietary/gfx"
	"hardware/renesas/proprietary/omx"
	"hardware/renesas/proprietary/usb"
)
added_dir_hardware_ti=(
	"hardware/ti/wl18xx"
)
added_dir_vendor_renesas_apps=(
	"vendor/renesas/apps/CarRadioApp"
        "vendor/renesas/apps/SoundRecorder"
	"vendor/renesas/apps/cms-test"
	"vendor/renesas/apps/evs"
)
added_dir_vendor_renesas_firmware=(
	"vendor/renesas/firmware/radio"
)
added_dir_vendor_renesas_hal=(
	"vendor/renesas/hal/audio"
	"vendor/renesas/hal/audiocontrol"
	"vendor/renesas/hal/audioeffect"
	"vendor/renesas/hal/bootctrl"
	"vendor/renesas/hal/c2"
	"vendor/renesas/hal/camera"
	"vendor/renesas/hal/cms"
	"vendor/renesas/hal/contexthub"
	"vendor/renesas/hal/dumpstate"
	"vendor/renesas/hal/evs"
	"vendor/renesas/hal/gnss"
	"vendor/renesas/hal/health"
	"vendor/renesas/hal/light"
	"vendor/renesas/hal/power"
	"vendor/renesas/hal/thermal"
	"vendor/renesas/hal/usb"
	"vendor/renesas/hal/usbgadget"
	"vendor/renesas/hal/vehicle"
)
added_dir_vendor_renesas_hardware=(
	"vendor/renesas/hardware/interfaces"
)
added_dir_vendor_renesas_utils=(
	"vendor/renesas/utils/fastboot"
	"vendor/renesas/utils/ipl-tools"
	"vendor/renesas/utils/libgpio"
	"vendor/renesas/utils/mmngr"
	"vendor/renesas/utils/optee-client"
	"vendor/renesas/utils/qos"
	"vendor/renesas/utils/si-tools"
	"vendor/renesas/utils/usb-scanner"
	"vendor/renesas/utils/vspmif"
)

added_dir_import=(

)
removed_dir=(
	"external/adt-infra"
	"tools/adt/idea"
	"tools/base"
	"tools/build"
	"tools/idea"
	"tools/motodev"
	"tools/studio/cloud"
	"tools/swt"
)
changed_dir_ignore=(
)
changed_dir=(
	"bootable/recovery"
	"build/make"
	"build/soong"
	"device/linaro/poplar"
	"frameworks/av"
	"frameworks/base"
	"frameworks/opt/net/wifi"
        "hardware/interfaces"
	"packages/apps/Bluetooth"
	"packages/apps/Car/LatinIME"
	"packages/apps/Car/Launcher"
        "packages/apps/Car/Settings"
	"packages/apps/SecureElement"
	"packages/providers/MediaProvider"
	"packages/services/Car"
	"packages/services/Telecomm"
	"system/bt"
	"system/core"
	"system/sepolicy"
)
changed_dir_rev=(
)
changed_dir_id=(
)
changed_dir_rev_id=(
)
