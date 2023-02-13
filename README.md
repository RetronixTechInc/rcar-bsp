# rcar-bsp


## Quick Start

1. Download 22R000-SB rootfs file. please use the following link:  
   [https://pse.is/4pfn6a](https://pse.is/4pfn6a)

1. Please reference this link to download RCar-Gen3-SDK:  
   [https://www.renesas.com/us/en/products/automotive-products/automotive-system-chips-socs/r-car-sdk-r-car-software-development-kit](https://www.renesas.com/us/en/products/automotive-products/automotive-system-chips-socs/r-car-sdk-r-car-software-development-kit)

1. Please follow this instruction to setup NFS server.  
  `Appendix in RENESAS_RCV3UV3HV3M_YoctoStartupGuide_UME.pdf (In Renesas SDK_vX.X/Yocto/docs/sw/yocto_linux/user_manual)`

1. Please follow this instruction to flash firmware.  
  `2022-Rtx-VEMS-SB-StartUpGuideWithNet.pdf`

1. Please follow this instruction to flash eMMC.  
  `2022-Rtx-VEMS-SB-StartUpGuideWithEmmc.pdf`


##
## How to use camera ov10635?

1. Copy ./Rtx_Tools/rtx_camera_display.sh to device.

1. Execute this script to display the ov10635 camera.  
   `Ex : ./rtx_camera_display.sh N (N is 0~7)`


##
## How to build Retronix kernel and Retronix u-boot in yocto project?

1. Copy ./Rtx_Recipes/linux-renesas_5.4.bbappend to <Your Yocto Project>/meta-renesas/meta-rcar-bsp/recipes-kernel/linux/

1. Copy ./Rtx_Recipes/u-boot_2020.01.bbappend to <Your Yocto Project>/meta-renesas/meta-rcar-bsp/recipes-bsp/u-boot/

Complete the above steps, when you build yocto project, your kernel and u-boot will be downloaded from git server of Retronix.
