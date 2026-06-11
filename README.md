#  Quick start[Ubuntu 20.04 LTS (64bit only)]

1. Download script
git clone https://github.com/RetronixTechInc/rcar-bsp.git -b v4h-sbc  

2. Using build script(build images of car-image-adas)
$ cd rcar-bsp  
$ ./build_yocto_v3p44.sh  

----- Build and Download images to PCBA refer to 101_Sparrow-Hawk-V4H_Porting_Guide.pdf -----
##  Build BSP and write to PCBA
* Please reference to 101_Sparrow-Hawk-V4H_Porting_Guide.pdf in chapter 3.

##  Download IPL images and write to PCBA:
* Download IPL images: [Sparrow-Hawk-IPL.zip](https://drive.google.com/file/d/1XWK0IWa689npNdfTO8JBgtPKYJ_IKkJ6/view?usp=drive_link)
* Uncompress the download zip file.
* Write IPL to PCBA reference to 101_Sparrow-Hawk-V4H_Porting_Guide.pdf in section 4.1.

##  Download FS images using pre-build or building images:
* Download pre-build image: [Sparrow-Hawk-FileSystem.zip](https://drive.google.com/file/d/1rUDFOI6g57XzEWG2LUIFoDOJhkmq3Cbb/view?usp=drive_link)
* Uncompress the download zip file.
* Write FS to PCBA reference to 101_Sparrow-Hawk-V4H_Porting_Guide.pdf from sections 4.2 to 4.4.


