#  Quick start[Ubuntu 20.04 LTS (64bit only)]

1. Download script  
git clone https://github.com/RetronixTechInc/rcar-bsp.git -b v4h-raptor  
git checkout -b bsp-3p28 raptor-bsp-3p28  

2. Using build script(build images of rcar-image-adas)  
$ cd rcar-BSP  
$ ./build_yocto_v3p28.sh  

----- Build and Download images to PCBA refer to 101_RRC-Raptor-V4H_Porting_Guide.pdf -----
##  Build BSP and write to PCBA
* Please reference to 101_RRC-Raptor-V4H_Porting_Guide.pdf in chapter 3.

##  Download IPL images and write to PCBA:
* Download IPL images: [RRC-V4H-Raptor-IPL.zip](https://drive.google.com/file/d/1R99EayEp9QGpzfY5o50F10v9c7Iv2L86/view?usp=drive_link)
* Uncompress the download zip file.
* Write IPL to PCBA reference to 101_RRC-Raptor-V4H_Porting_Guide.pdf in section 4.1.

##  Download FS images using pre-build or building images:
* Download pre-build image: [RRC-Raptor-FileSystem-images.zip](https://drive.google.com/file/d/1T58m_WcsJv3Re5I7cOWSABEyURbllz4v/view?usp=sharing)
* Uncompress the download zip file.
* Write FS to PCBA reference to 101_RRC-Raptor-V4H_Porting_Guide.pdf from sections 4.2 to 4.4.


