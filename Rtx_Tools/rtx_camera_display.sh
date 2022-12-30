#!/bin/sh

INDEX=$1

media-ctl -d /dev/media0 -r


media-ctl -d /dev/media0 -l "'rcar_csi2 feaa0000.csi_00':1 -> 'VIN0 output':0 [1]"
media-ctl -d /dev/media0 -l "'rcar_csi2 feaa0000.csi_00':2 -> 'VIN1 output':0 [1]"
media-ctl -d /dev/media0 -l "'rcar_csi2 feaa0000.csi_00':3 -> 'VIN2 output':0 [1]"
media-ctl -d /dev/media0 -l "'rcar_csi2 feaa0000.csi_00':4 -> 'VIN3 output':0 [1]"

media-ctl -d /dev/media0 -V "'rcar_csi2 feaa0000.csi_00':1 [fmt:UYVY8_2X8/1280x800 field:none]"

media-ctl -d /dev/media0 -l "'rcar_csi2 feab0000.csi_01':1 -> 'VIN4 output':0 [1]"
media-ctl -d /dev/media0 -l "'rcar_csi2 feab0000.csi_01':2 -> 'VIN5 output':0 [1]"
media-ctl -d /dev/media0 -l "'rcar_csi2 feab0000.csi_01':3 -> 'VIN6 output':0 [1]"
media-ctl -d /dev/media0 -l "'rcar_csi2 feab0000.csi_01':4 -> 'VIN7 output':0 [1]"

media-ctl -d /dev/media0 -V "'rcar_csi2 feab0000.csi_01':1 [fmt:UYVY8_2X8/1280x800 field:none]"


echo Init Finish !!!!


if [ "$#" -ne 1 ]; then
    echo "Must input video index !!!"
    exit 0
fi

echo "Video INDEX = $INDEX"

echo "========================================"
echo "gst-launch-1.0 v4l2src device=/dev/video$INDEX ! videoconvert! videoscale ! video/x-raw, width=1280, height=800, framerate=30/1 ! fbdevsink -evvv"

echo "========================================"
gst-launch-1.0 v4l2src device=/dev/video$INDEX ! videoconvert! videoscale ! video/x-raw, width=1280, height=800, framerate=30/1 ! fbdevsink -evvv


exit 0
