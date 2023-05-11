#! /bin/bash
# 1 : OFF, 0 : ON
#Download mode  : SW1800[8:1] = 01111000 , SW1801[8:1] = 00010000
#SPI Flash mode : SW1800[8:1] = 00010000 , SW1801[8:1] = 00010000

#Tom_2023/02/23

TTY_NODE="/dev/ttyUSB0"

INTERVAL_SLEEP=2
SUDOCMD="sudo"

DATAPATH="."

FLASH_WRITER=`ls ${DATAPATH}/AArch64_Gen3_H3_M3_Scif_MiniMon_V5.13.mot`

FLASH_FILE_0=`ls ${DATAPATH}/bootparam_sa0.srec`
FLASH_FILE_1=`ls ${DATAPATH}/bl2.srec`
FLASH_FILE_2=`ls ${DATAPATH}/cert_header_sa6.srec`
FLASH_FILE_3=`ls ${DATAPATH}/bl31.srec`
FLASH_FILE_4=`ls ${DATAPATH}/tee.srec`
FLASH_FILE_5=`ls ${DATAPATH}/u-boot-elf.srec`

FLASH_PARTITION_0="E6320000:000000:${FLASH_FILE_0}"
FLASH_PARTITION_1="E6304000:040000:${FLASH_FILE_1}"
FLASH_PARTITION_2="E6320000:180000:${FLASH_FILE_2}"
FLASH_PARTITION_3="44000000:1C0000:${FLASH_FILE_3}"
FLASH_PARTITION_4="44100000:200000:${FLASH_FILE_4}"
FLASH_PARTITION_5="50000000:640000:${FLASH_FILE_5}"

FLASH_PARTITION="FLASH_PARTITION_0 FLASH_PARTITION_1 FLASH_PARTITION_2 FLASH_PARTITION_3 FLASH_PARTITION_4 FLASH_PARTITION_5"
#~ FLASH_PARTITION="FLASH_PARTITION_0 FLASH_PARTITION_1"
#~ FLASH_PARTITION="FLASH_PARTITION_1"

Load_FlashWriter()
{
	echo "Load FlashWriter ${FLASH_WRITER}....."
	echo "${SUDOCMD} dd if=${FLASH_WRITER} of=${TTY_NODE}"
	stty -F ${TTY_NODE} 115200
	sleep 0.5
	${SUDOCMD} dd if=${FLASH_WRITER} of=${TTY_NODE}
	sync
	sleep 0.5
	echo -ne "\r" > ${TTY_NODE}
	
	echo "OK"
}

ChangeSUP()
{
	echo "Change SUP....."
	
	stty -F ${TTY_NODE} 115200
	echo -ne "SUP\r" > ${TTY_NODE}
	sleep 1
	#stty -F ${TTY_NODE} 921600 -echo -icanon -onlcr
	stty -F ${TTY_NODE} 921600 -onlcr
	
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
		
		echo -ne "xls2\r" > ${TTY_NODE}
		sleep "$INTERVAL_SLEEP"
		echo -ne "${ARG_TOP_ADDR}\r" > ${TTY_NODE}
		sleep "$INTERVAL_SLEEP"
		echo -ne "${ARG_SAVE_ADDR}\r" > ${TTY_NODE}
		sleep "$INTERVAL_SLEEP"
		${SUDOCMD} dd if="${ARG_FILE_NAME}" of="${TTY_NODE}"
		sync
		sleep 3
	done
	
	stty -F ${TTY_NODE} 115200
	sleep 0.5
}

if [ ! -c "$TTY_NODE" ]; then
	echo "${TTY_NODE} is not exist !!!"
	exit 0
fi

Load_FlashWriter
ChangeSUP
Flash_Writer_All

echo "write finished!!!"
