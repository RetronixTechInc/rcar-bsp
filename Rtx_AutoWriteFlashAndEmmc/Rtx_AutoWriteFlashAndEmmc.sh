#! /bin/bash

#2022/8/03 When execute script, need to open picocom.
#2022/8/05 When execute script, don't need to open picocom..
#2022/8/12 Add only write u-boot function.

#Jerry_08/012

TTY_NODE="/dev/ttyUSB0"

MAX_SIZE=8388608
MAX_SECTOR=`expr ${MAX_SIZE} / 512`
INTERVAL_SLEEP=1

DATAPATH="."

FLASH_WRITER='ls ${DATAPATH}/ICUMXA_Flash_writer_SCIF_DUMMY_CERT_EB200400_condor.mot'

FLASH_FILE_0=`ls ${DATAPATH}/bootparam_sa0.srec`
FLASH_FILE_1=`ls ${DATAPATH}/icumxa_loader*.srec`
FLASH_FILE_2=`ls ${DATAPATH}/dummy_fw.srec`
FLASH_FILE_3=`ls ${DATAPATH}/cert_header_sa6.srec`
FLASH_FILE_4=`ls ${DATAPATH}/dummy_rtos.srec`
FLASH_FILE_5=`ls ${DATAPATH}/bl31*.srec`
FLASH_FILE_6=`ls ${DATAPATH}/u-boot-elf-condor.srec`

FLASH_PARTITION_0="EB200000:000000:${FLASH_FILE_0}"
FLASH_PARTITION_1="EB2D8000:040000:${FLASH_FILE_1}"
FLASH_PARTITION_2="EB2B4000:0C0000:${FLASH_FILE_2}"
FLASH_PARTITION_3="EB200000:180000:${FLASH_FILE_3}"
FLASH_PARTITION_4="EB200000:1C0000:${FLASH_FILE_4}"
FLASH_PARTITION_5="46400000:2C0000:${FLASH_FILE_5}"
FLASH_PARTITION_6="50000000:840000:${FLASH_FILE_6}"

FLASH_PARTITION="FLASH_PARTITION_0 FLASH_PARTITION_1 FLASH_PARTITION_2 FLASH_PARTITION_3 FLASH_PARTITION_4 FLASH_PARTITION_5"

Load_FlashWriter()
{
	echo "Load FlashWriter....."
	echo "sudo dd if=./ICUMXA_Flash_writer_SCIF_DUMMY_CERT_EB200400_condor_SVM.mot of=/dev/ttyUSB0"
	stty -F /dev/ttyUSB0 115200
	sleep 0.5
	sudo dd if=./ICUMXA_Flash_writer_SCIF_DUMMY_CERT_EB200400_condor_SVM.mot of=/dev/ttyUSB0
	sync
	sleep 0.5
	
	echo "OK"
}

ChangeSUP()
{
	echo "Change SUP....."
	
	stty -F /dev/ttyUSB0 115200
	echo -ne "SUP\r" > /dev/ttyUSB0
	sleep 1
	#stty -F /dev/ttyUSB0 921600 -echo -icanon -onlcr
	stty -F /dev/ttyUSB0 921600 -onlcr
	
	echo "OK"
}

Flash_Writer_All()
{
	for PARTITION_INFO_TMP in ${FLASH_PARTITION}
	do
		#echo "PARTITION_INFO_TMP = ${PARTITION_INFO_TMP}"
		eval PARTITION_INFO=\$${PARTITION_INFO_TMP}
		#echo "PARTITION_INFO = ${PARTITION_INFO}"

		if [ "${PARTITION_INFO}" == "" ]
		then
			continue ;
		fi

		ARG_TOP_ADDR=`echo ${PARTITION_INFO} | awk -F':' '{print $1}'`
		ARG_SAVE_ADDR=`echo ${PARTITION_INFO} | awk -F':' '{print $2}'`
		ARG_FILE_NAME=`echo ${PARTITION_INFO} | awk -F':' '{print $3}'`
		
		echo "ARG_TOP_ADDR = ${ARG_TOP_ADDR}"
		echo "ARG_SAVE_ADDR = ${ARG_SAVE_ADDR}"
		echo "ARG_FILE_NAME = ${ARG_FILE_NAME}"
		
		echo -ne "xls2\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		echo -ne "3\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		echo -ne "y\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		echo -ne "y\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		echo -ne "${ARG_TOP_ADDR}\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		echo -ne "${ARG_SAVE_ADDR}\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		sudo dd if="${ARG_FILE_NAME}" of="${TTY_NODE}"
		sync
		sleep "$INTERVAL_SLEEP"
		echo -ne "y\r" > /dev/ttyUSB0
		sleep 3
		
		
	done
}

Flash_Writer_uboot()
{
	#echo "FLASH_PARTITION_6 = ${FLASH_PARTITION_6}"
	eval PARTITION_INFO=\$${FLASH_PARTITION_6}
	#echo "PARTITION_INFO = ${PARTITION_INFO}"

	if [ "${PARTITION_INFO}" == "" ]
	then
		continue ;
	fi

	ARG_TOP_ADDR=`echo ${PARTITION_INFO} | awk -F':' '{print $1}'`
	ARG_SAVE_ADDR=`echo ${PARTITION_INFO} | awk -F':' '{print $2}'`
	ARG_FILE_NAME=`echo ${PARTITION_INFO} | awk -F':' '{print $3}'`
	
	echo "ARG_TOP_ADDR = ${ARG_TOP_ADDR}"
	echo "ARG_SAVE_ADDR = ${ARG_SAVE_ADDR}"
	echo "ARG_FILE_NAME = ${ARG_FILE_NAME}"
	
	echo -ne "xls2\r" > /dev/ttyUSB0
	sleep "$INTERVAL_SLEEP"
	echo -ne "3\r" > /dev/ttyUSB0
	sleep "$INTERVAL_SLEEP"
	echo -ne "y\r" > /dev/ttyUSB0
	sleep "$INTERVAL_SLEEP"
	echo -ne "y\r" > /dev/ttyUSB0
	sleep "$INTERVAL_SLEEP"
	echo -ne "${ARG_TOP_ADDR}\r" > /dev/ttyUSB0
	sleep "$INTERVAL_SLEEP"
	echo -ne "${ARG_SAVE_ADDR}\r" > /dev/ttyUSB0
	sleep "$INTERVAL_SLEEP"
	sudo dd if="${ARG_FILE_NAME}" of="${TTY_NODE}"
	sync
	sleep "$INTERVAL_SLEEP"
	echo -ne "y\r" > /dev/ttyUSB0
	sleep 3
}

Load_File_To_Emmc()
{
	SKIP=0

	START_ADDR_HEX=$1
	FILE_PATH_NAME=$2
	echo "FILE_PATH_NAME = ${FILE_PATH_NAME}"
	
	if [ -z $FILE_PATH_NAME ]
	then	
		echo "Cannot find file!!!( Load_File_To_Emmc() )" 
		exit 0
	fi
	
	SIZE_FILE=`ls -l ${FILE_PATH_NAME} | awk '{ print $5}'`
	ADDR_CURRENT=`printf %d ${START_ADDR_HEX}`
	SIZE_CURRENT=
	HEX_SIZE=

	while true
	do
		
		#echo "SIZE_FILE = ${SIZE_FILE}"

		HEX_ADDR=`printf %x ${ADDR_CURRENT}`
		
		if [ $SIZE_FILE -gt $MAX_SIZE ]
		then
			SIZE_CURRENT=$MAX_SIZE

		else
			SIZE_CURRENT=$SIZE_FILE
		fi
		
		HEX_ADDR=`printf %x ${ADDR_CURRENT}`
		HEX_SIZE=`printf %x ${SIZE_CURRENT}`
		echo "HEX_ADDR = ${HEX_ADDR}"
		echo "HEX_SIZE = ${HEX_SIZE}"
		#echo "sudo dd if=${FILE_PATH_NAME} of=/dev/ttyUSB0 bs=1M count=8 skip=${SKIP}"

		echo -ne "em_wb\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		echo -ne "0\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		echo -ne "${HEX_ADDR}\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		echo -ne "${HEX_SIZE}\r" > /dev/ttyUSB0
		sleep "$INTERVAL_SLEEP"
		
		echo "sudo dd if=${FILE_PATH_NAME} of=/dev/ttyUSB0 bs=1M count=8 skip=${SKIP}"
		sudo dd if=${FILE_PATH_NAME} of=/dev/ttyUSB0 bs=1M count=8 skip=${SKIP}
		sync
		sleep "$INTERVAL_SLEEP"
		
		ADDR_CURRENT=`expr ${ADDR_CURRENT} + ${MAX_SECTOR} `
		SIZE_FILE=`expr ${SIZE_FILE} - ${MAX_SIZE}`
		SKIP=`expr ${SKIP} + 8`
		
		if [ $SIZE_FILE -lt 0 ]
		then
			break
		fi
		
	done
}

func_flash()
{
	Load_FlashWriter
	ChangeSUP
	Flash_Writer_All
}

func_uboot()
{
	Load_FlashWriter
	ChangeSUP
	Flash_Writer_uboot
}

func_uImage()
{
	HEX_ADDR_START=0x6800
	FILE_PATH=`ls ./Image*`
	Load_FlashWriter
	ChangeSUP
	Load_File_To_Emmc $HEX_ADDR_START $FILE_PATH
}

func_dtb()
{
	HEX_ADDR_START=0x6400
	FILE_PATH=`ls ./*.dtb`
	Load_FlashWriter
	ChangeSUP
	Load_File_To_Emmc $HEX_ADDR_START $FILE_PATH
}

func_ramdisk()
{
	HEX_ADDR_START=0x18800
	FILE_PATH=`ls ./uramdisk-recovery-SVM.img`
	Load_FlashWriter
	ChangeSUP
	Load_File_To_Emmc $HEX_ADDR_START $FILE_PATH
}

func_all()
{
	Load_FlashWriter
	ChangeSUP
	Flash_Writer_All
	Flash_Writer_uboot
	
	HEX_ADDR_START=0x6800
	FILE_PATH=`ls ./Image*`
	Load_File_To_Emmc $HEX_ADDR_START $FILE_PATH
	
	HEX_ADDR_START=0x6400
	FILE_PATH=`ls ./*.dtb`
	Load_File_To_Emmc $HEX_ADDR_START $FILE_PATH
	
	HEX_ADDR_START=0x18800
	FILE_PATH=`ls ./uramdisk-recovery-SVM.img`
	Load_File_To_Emmc $HEX_ADDR_START $FILE_PATH
}

if [ ! -c "$TTY_NODE" ]; then
	echo "$TTY_NODE is not exist !!!"
	exit 0
fi

case "${1}" in
	"all")
		func_all
		;;
	"flash")
		func_flash
		func_uboot
		;;
	"uboot")
		func_uboot
		;;
	"uImage")
		func_uImage
		;;
	"dtb")
		func_dtb
		;;
	"ramdisk")
		func_ramdisk
		;;
	*) 
		echo "${0} [all/flash/uboot/dtb/uImage/ramdisk]"
		exit 1
		;;
esac
