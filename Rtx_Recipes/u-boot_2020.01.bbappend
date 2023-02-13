DESCRIPTION = "Linux u-boot for the R-Car Generation 3 based board"

#SRCREV = "${AUTOREV}"
SRCREV = "5e8ffbd8625dd49a491788851837b6692a2db6dc"

RTX_UBOOT_URL = "git://github.com/RetronixTechInc/rcar-uboot.git;protocol=https"
RTX_BRANCH = "main"

SRC_URI = "${RTX_UBOOT_URL};branch=${RTX_BRANCH}"
