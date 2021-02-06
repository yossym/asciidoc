#!/bin/bash
#!/bin/bash -ux

cd `dirname $0`

######################################
# show xx comand variable defination
######################################
readonly TIMEOUT=10
readonly IPS_TABLE_FILENAME="IpsTable.txt"

#TIME_NOW=$(date +"%F_%H-%M-%S")
#TIME_NOW=$(date +"%F")
readonly TIME_NOW=$(date +"%F")

readonly LOG_NEIGHBOR_AP_FILENAME="NeighborAp_${TIME_NOW}.csv"
readonly LOG_STATION_FILENAME="Station_${TIME_NOW}.csv"
readonly LOG_WLAN_FILENAME="Wlan_${TIME_NOW}.csv"
readonly LOG_RADAR_FILENAME="Rader_${TIME_NOW}.csv"

# 各種ログイン情報
username=""
password=""
community_name=""

CmdLogFileName="Command_${TIME_NOW}.log"


########################################
# snmp-walk comand variable defination
########################################

#本番SSID MID OID
# "1.3.6.1.4.1.258.46.3.201.2.1.1.1.2.1"
#                                 ^ ^ ^---- wlan 1/2
#                                 | +------ interface IFXX
#                                 +-------- Input=1,Output=2

readonly TRAFFIC_MIB="1.3.6.1.4.1.258.46.3.201.2.1.1"
readonly MIB_IN_IF02_WLAN1="1.3.6.1.4.1.258.46.3.201.2.1.1.1.2.1"
readonly MIB_OUT_IF02_WLAN1="1.3.6.1.4.1.258.46.3.201.2.1.1.2.2.1"

readonly MIB_IN_IF05_WLAN1="1.3.6.1.4.1.258.46.3.201.2.1.1.1.5.1"
readonly MIB_OUT_IF05_WLAN1="1.3.6.1.4.1.258.46.3.201.2.1.1.2.5.1"

readonly MIB_IN_IF02_WLAN2="1.3.6.1.4.1.258.46.3.201.2.1.1.1.2.2"
readonly MIB_OUT_IF02_WLAN2="1.3.6.1.4.1.258.46.3.201.2.1.1.2.2.2"

readonly MIB_IN_IF05_WLAN2="1.3.6.1.4.1.258.46.3.201.2.1.1.1.5.2"
readonly MIB_OUT_IF05_WLAN2="1.3.6.1.4.1.258.46.3.201.2.1.1.2.5.2"

#アソシエーション情報 MIB OID
readonly AssociationInfomation="1.3.6.1.4.1.258.46.3.201.3"

function_result=0




function get_ap_info()
{
	#get_ap_info ${hostname} ${username} ${password} ${tempfile} ${TIMEOUT}

	/usr/bin/expect -c "
	set timeout "${5}"

	set hostname "${1}"
	set username "${2}"
	set password "${3}"
	log_file "${4}"

	spawn ssh $username@$hostname

	expect { 
		default { exit 1; }
		password {send $password\n }
		(yes/no) {
			send yes\n
			expect password:
			send $password\n
			} 
	}

	expect  # 
	send \"show status system\n\"

	expect  # 
	send \"show status neighborap\n\"

	expect  # 
	send \"show status station\n\"

	expect  # 
	send \"show status wlan 1\n\"

	expect  # 
	send \"show status wlan 2\n\"

	expect  # 
	send \"show status radar\n\"

	expect  # 
	send exit\n
	expect logout
	"
#	echo "######################################## get_ap_info"
#	echo '$? ' $?
	
	return 0
}

function write_radar_log()
{
	#write_radar_log ${DT} ${TM} ${hostname} ${tempfile2} ${LOG_RADAR_FILENAME}
	local time="${1} ${2}"
	local ip=${3}
	local infile=${4}
	local outfile=${5}

	if [ ! -s ${outfile} ]; then
		echo 	"time,AP IP,Detect Time,Ch,ChWidth" > ${outfile}
	fi

	awk -v time="${time}" -v ip=${ip}  'BEGIN{OFS=",";} \
	/status radar/,/exit/	{	\
		if ( /:/ ) {	\
			DetectTimeText=substr($0,1,19); \
			ChText=substr($0,22,4); \
			ChWidthText=substr($0,27,8); \
			print time,ip,DetectTimeText,ChText,ChWidthText; \
		} \
	} \
	' ${infile} >> ${outfile}

}

function write_wlan_log()
{
	#write_wlan_log ${DT} ${TM} ${hostname} ${tempfile2} ${LOG_WLAN_FILENAME}
	local time="${1} ${2}"
	local ip=${3}
	local infile=${4}
	local outfile=${5}

	if [ ! -s ${outfile} ]; then
		echo 	"time,AP IP,If Index,Oparation,Radio State,Beacon Period,Channel,Resource Utilization,Power Level" > ${outfile}
	fi

	awk -v time="${time}" -v ip=${ip} 'BEGIN{OFS=",";} \
	/status wlan/			{ IfIndex=$NF; } \
	/Operation/				{ OparationText=substr($0,25,80); } \
	/Radio/					{ RadioText=substr($0,25,80);} \
	/Beacon Period/			{ BeaconText=substr($0,25,80);gsub("ms","",BeaconText);} \
	/^Channel/ 				{ ChannelText=substr($0,25,80);} \
	/Resource Utilization/	{ RUtilizationText= substr($0,25,80);gsub("%","",RUtilizationText);} \
	/Power Level/			{ PowerLevelText=substr($0,25,80);gsub("dBm","",PowerLevelText);} \
	/Protection/	{ \
		printf("%s,%s,%s,%s,%s,%s,%s,%s,%s\n", \
			time,ip,IfIndex,OparationText,RadioText, \
			BeaconText,ChannelText,RUtilizationText,PowerLevelText); \
	} \
	' ${infile} >> ${outfile}

	return 0
}

function write_station_log()
{
	#write_station_log 	${DT} ${TM} ${hostname} ${tempfile2} ${LOG_STATION_FILENAME}
	local time="${1} ${2}"
	local ip=${3}
	local infile=${4}
	local outfile=${5}

	if [ ! -s ${outfile} ]; then

		echo "time,AP IP,MAC Address,Associated Time,Mode,RSSI,Tx/Rx Rate,SSID Name"  > ${outfile}
	fi

	awk -v time="${time}" -v ip=${ip}  'BEGIN{OFS=",";} \
	/status station/,/status wlan/{ \
		if ( /:/ ) { \
			MacAddressText=substr($0,1,17); \
			AssociatedTimeText=substr($0,19,19); \
			ModeText=substr($0,39,9); \
			gsub(" ","",ModeText); \
			RssiText=substr($0,48,5); \
			gsub(" ","",RssiText); \
			TxRxRateText=substr($0,53,11); \
			gsub(" ","",TxRxRateText); \
			SsidNameText=substr($0,64,18); \
			gsub(" ","",SsidNameText); \
			print time,ip,MacAddressText,AssociatedTimeText, \
			ModeText,RssiText,TxRxRateText,SsidNameText; \
		} \
	} \
	' ${infile} >> ${outfile}

	return 0
}

function write_neighborap_log()
{
	#write_neighborap_log ${DT} ${TM} ${hostname} ${tempfile2} ${LOG_NEIGHBOR_AP_FILENAME}
	local time="${1} ${2}"
	local ip=${3}
	local infile=${4}
	local outfile=${5}

	if [ ! -s ${outfile} ]; then
		echo "time,AP IP,BSSID,SSID,RSSI,Ch,ChWidth,Mode,IF" > ${outfile}
	fi

	awk -v time="${time}" -v ip=${ip}  'BEGIN{OFS=",";} \
	/status neighborap/,/status station/{ \
		if ( /:/ ) { \
			BssidText=substr($0,1,17); \
			SsidText=substr($0,20,18); \
			gsub("^[ ]+", "",SsidText); \
			gsub("[ ]+$", "",SsidText); \
			RssiText=substr($0,38,5); \
			gsub(" ","",RssiText); \
			ChText=substr($0,44,5); \
			gsub(" ","",ChText); \
			ChWidthText=substr($0,50,9); \
			gsub(" ","",ChWidthText); \
			ModeText=substr($0,60,9); \
			gsub(" ","",ModeText); \
			IfText=substr($0,70,9); \
			gsub(" ","",IfText); \
			print time,ip,BssidText,SsidText, \
			RssiText,ChText,ChWidthText,ModeText,IfText; \
		} \
	} \
	' ${infile} >> ${outfile}


	return 0
}

function get_show_cmd()
{
	local hostname=${1}

	local DT=$(date +"%F")
	local TM=$(date +"%H:%M:%S")

	local LogFileName="AccessPoint_${hostname}_${TIME_NOW}.log"

	local START_TIME="# ${hostname} : start time ${DT} ${TM}"
	local tempfile=$(mktemp)
#	echo ${tempfile}
	echo ${START_TIME} >> ${tempfile}
	echo >> ${tempfile}

	echo ${START_TIME}

	get_ap_info ${hostname} ${username} ${password} ${tempfile} ${TIMEOUT}

#	echo "######################################## get_show_cmd"
#	echo '$? ' $?

	echo >> ${tempfile}
	echo >> ${tempfile}

	local END_TIME="# ${hostname} : end time $(date +"%F %H:%M:%S")"
	echo ${END_TIME} >> ${tempfile}

	local tempfile2=$(mktemp)

	# 不要なエスケープシーケンス削除
	cat ${tempfile} | tr -d '\r' > ${tempfile2}
	sed -i -e 's/\x1B\[[0-9]\?[mKJH]//g' ${tempfile2}

	write_neighborap_log 	${DT} ${TM} ${hostname} ${tempfile2} ${LOG_NEIGHBOR_AP_FILENAME}
	write_station_log 		${DT} ${TM} ${hostname} ${tempfile2} ${LOG_STATION_FILENAME}
	write_wlan_log     		${DT} ${TM} ${hostname} ${tempfile2} ${LOG_WLAN_FILENAME}
	write_radar_log			${DT} ${TM} ${hostname} ${tempfile2} ${LOG_RADAR_FILENAME}

#	cat ${tempfile2} >> ${LogFileName}

	sed -e 's#$#\r#g' ${tempfile2}  >> ${LogFileName}


	rm ${tempfile}
	rm ${tempfile2}
}

function get_snmp_cmd_new()
{
	local apip=${1}
	local now=${2}

	local DT=$(date "+%Y/%m/%d")
	local TM=$(date "+%H:%M:%S")

	local LogSnmpFileName="adhoc-all-snmp_${now}.csv"
	local LogSnmpRowFilename="snmp_${apip}_${now}.log"

	if [ ! -s ${LogSnmpFileName} ]; then
		echo 	"time,AP IP,Input If05 Wlan1,Output If05 Wlan1,Input If05 Wlan2,Output If05 Wlan2,Associated Count" > ${LogSnmpFileName}
	fi

	local tempfile=$(mktemp)
	echo "${apip} : snmpwalk run time ${DT} ${TM} "
	echo "${apip} : snmpwalk run time ${DT} ${TM} "  >> ${tempfile}

	local snmpwalk_result=$(snmpwalk -v2c -c ${community_name} -O n ${apip} ${TRAFFIC_MIB})
	if [ ${#snmpwalk_result} -gt 1 ]; then
		echo "=${snmpwalk_result}="

		echo ${snmpwalk_result} | sed -e 's/.1.3.6.1.4.1.258/\n.1.3.6.1.4.1.258/g' >> ${tempfile}

		snmpwalk_result=$(snmpwalk -v2c -c ${community_name} -O n ${apip} ${AssociationInfomation})
		echo ${snmpwalk_result} | sed -e 's/.1.3.6.1.4.1.258/\n.1.3.6.1.4.1.258/g' >> ${tempfile}

	
		local InputIf05Wlan1=$( grep -e ${MIB_IN_IF05_WLAN1} ${tempfile} | awk '{print $NF}' )
		local OutputIf05Wlan1=$(grep -e ${MIB_OUT_IF05_WLAN1} ${tempfile} | awk '{print $NF}' )
		local InputIf05Wlan2=$(grep -e ${MIB_IN_IF05_WLAN2} ${tempfile} | awk '{print $NF}' )
		local OutputIf05Wlan2=$(grep -e ${MIB_OUT_IF05_WLAN2} ${tempfile} | awk '{print $NF}' )
		local AssocCount=$(grep -e ${AssociationInfomation} ${tempfile} | grep -c 'Hex-STRING' )
	fi
		sed -e 's#$#\r#g' ${tempfile}  >> ${LogSnmpRowFilename}
		
		if [  -n "${InputIf05Wlan1}"  -a  -n "${OutputIf05Wlan1}" ]; then
			printf "%s %s,%s,%s,%s,%s,%s,%s\n" ${DT} ${TM} ${apip} ${InputIf05Wlan1} ${OutputIf05Wlan1} ${InputIf05Wlan2} ${OutputIf05Wlan2} ${AssocCount} >>  ${LogSnmpFileName}
			function_result=0
			return 0
		else
			function_result=1
			return 1
		fi

}


function make_ips_table_filename()
{
	if [ !  -e ${IPS_TABLE_FILENAME}  ]; then
		echo 
		echo "APのIP一覧ファイル「${IPS_TABLE_FILENAME}」が見つからないので実行を継続できません。"
		echo "IP一覧ファイルを作成するので、測定したいAPのIPアドレスを編集してください。\r\n"
		echo 
		printf "# #を含む行はコメント\r\n" 	> ${IPS_TABLE_FILENAME}
		printf "# 空行は読み飛ばす\r\n"		>> ${IPS_TABLE_FILENAME}

		printf "10.15.34.80\r\n"		>> ${IPS_TABLE_FILENAME}

		exit 1
	fi
}

function usage()
{

	echo "Panasonic AP から トラフィック情報等を取得するスクリプト"
	echo "$0 -u <ap login username> -p < ap login password> -c <ap SNMP Community Name>"
	echo ""
	echo " Example:"
	echo "$0 -u root -p root -c public"
	
	exit 1

}

function main()
{
	make_ips_table_filename 

	if [ ! -s ${CmdLogFileName} ]; then
		echo 	"start time,end time,ap count" > ${CmdLogFileName}
	fi

	local CmdStartTime=$(date +"%F %H-%M-%S")
	
	local ap_count=0
	local ipaddress
	while read ipaddress
	do
		# 改行削除
		ipaddress=$(echo ${ipaddress} | tr -d \\r)
		if   [[ !  "$ipaddress" =~ \#   ]] ; then
			if [ -n "$ipaddress" ]; then

				function_result=0
				get_snmp_cmd_new ${ipaddress} ${TIME_NOW}
#				if  [ ${function_result} -eq 0 ]; then
					get_show_cmd ${ipaddress}
#				fi
				ap_count=$(( ${ap_count}  + 1 ))

			fi
		fi
	done < ${IPS_TABLE_FILENAME}

	local CmdEndTime=$(date +"%F %H-%M-%S")

	echo "${CmdStartTime},${CmdEndTime},${ap_count}" >> ${CmdLogFileName}

	
	return 0
}

############################
# main function
############################

	if [ $# -ne 6 ]; then
		usage
	fi

	while getopts "u:p:c:" OPT
	do

		case ${OPT} in
			u) username=$OPTARG;;
			p) password=$OPTARG;;
			c) community_name=$OPTARG;;
			h) 
				usage;;
			\?)
				usage;;
		esac
	done
	
	shift $((OPTIND - 1))

main

