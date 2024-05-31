DESCRIPTION = "Linux kernel for the R-Car Generation 3 based board"

#SRCREV = "${AUTOREV}"
SRCREV = "e60c8171b6df04654ea2e2a290175f0c53e0ef48"

RTX_BSP_BRANCH = "main_sb"
RTX_BSP_URI = "git://github.com/RetronixTechInc/rcar-kernel.git;protocol=git"
SRC_URI = "${RTX_BSP_URI};protocol=git;nocheckout=1;branch=${RTX_BSP_BRANCH}"

