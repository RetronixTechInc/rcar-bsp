DESCRIPTION = "Linux kernel for the R-Car Generation 3 based board"

#SRCREV = "${AUTOREV}"
SRCREV = "10eaa9ded9d3d88156c59dbe38e6fef857deae1f"

RTX_BSP_BRANCH = "main_sb"
RTX_BSP_URI = "git://github.com/RetronixTechInc/rcar-kernel.git;protocol=git"
SRC_URI = "${RTX_BSP_URI};protocol=git;nocheckout=1;branch=${RTX_BSP_BRANCH}"

