#  Quick start[Ubuntu 20.04 LTS (64bit only)]

1. Download script
git clone https://github.com/RetronixTechInc/rcar-bsp.git -b v4h-hel

2. Using build script(build images of car-image-adas)
$ cd rcar-bsp
$ ./build_yocto_v3p28.sh

----- Build and Download images to PCBA refer to 101_HEL-V4H_Porting_Guide.pdf -----
##  Build BSP and write to PCBA
* Please reference to 101_HEL-V4H_Porting_Guide.pdf in chapter 3.

##  Download IPL images and write to PCBA:
* Download IPL images: [RRC-V4H-HEL-IPL.zip](https://)
* Uncompress the download zip file.
* Write IPL to PCBA reference to 101_HEL-V4H_Porting_Guide.pdf in section 4.1.

##  Download FS images using pre-build or building images:
* Download pre-build image: [RRC-HEL-FileSystem-images.zip](https://)
* Uncompress the download zip file.
* Write FS to PCBA reference to 101_HEL-V4H_Porting_Guide.pdf from sections 4.2 to 4.4.


