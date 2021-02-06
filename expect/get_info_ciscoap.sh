#!/bin/bash -ux
#!/bin/bash

cd `dirname $0`

# show xx comand variable defination
######################################
readonly TIMEOUT=10
readonly IPS_TABLE_FILENAME="IpsTable.txt"


readonly TIME_NOW=$(date +"%F")


function get_ap_info()
{
	#get_ap_info ${hostname} ${username} ${password} ${tempfile} ${TIMEOUT}

	/usr/bin/expect -c "
	exp_internal 1
	set timeout "${5}"

	set hostname "${1}"
	set username "${2}"
	set password "${3}"
	log_file "${4}"

	spawn ssh $hostname

	expect { 
		default { exit 1; }
		User:	{ send $username\n
			expect Password:
			send $password\n }
		password {send $password\n }
		(yes/no) {
			send yes\n
			expect password:
			send root\n
			} 
	}

	expect   \") \>\"
	send \"config paging disable\n\"

	expect   \") \>\"
	send \"show sysinfo\n\"

	expect   \") \>\"
	send \"show wlan summary\n\"

	expect   \") \>\"
	send \"show ap summary\n\"

	expect   \") \>\"
	send logout\n
	expect (y/N)
	send N
	expect Connection
	"
#	echo "######################################## get_ap_info"
#	echo '$? ' $?
	
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

	get_ap_info ${hostname} ${username} ${password} "cisco.log" ${TIMEOUT}

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

#	write_neighborap_log 	${DT} ${TM} ${hostname} ${tempfile2} ${LOG_NEIGHBOR_AP_FILENAME}
#	write_station_log 		${DT} ${TM} ${hostname} ${tempfile2} ${LOG_STATION_FILENAME}
#	write_wlan_log     		${DT} ${TM} ${hostname} ${tempfile2} ${LOG_WLAN_FILENAME}
#	write_radar_log			${DT} ${TM} ${hostname} ${tempfile2} ${LOG_RADAR_FILENAME}

#	cat ${tempfile2} >> ${LogFileName}

	sed -e 's#$#\r#g' ${tempfile2}  >> ${LogFileName}


	rm ${tempfile}
	rm ${tempfile2}
}

function get_snmp_cmd_new ()
{
	return 0
}



function main()
{
	make_ips_table_filename 
	
	local ipaddress
	while read ipaddress
	do
		# 改行削除
		ipaddress=$(echo ${ipaddress} | tr -d \\r)
		if   [[ !  "$ipaddress" =~ \#   ]] ; then
			if [ -n "$ipaddress" ]; then

				function_result=0
#				get_snmp_cmd_new ${ipaddress} ${TIME_NOW}
#				if  [ ${function_result} -eq 0 ]; then
					get_show_cmd ${ipaddress}
#				fi

			fi
		fi
	done < ${IPS_TABLE_FILENAME}

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

	<<COMMENT

AP Name             Slots  AP Model              Ethernet MAC       Location          Country     IP Address       Clients   DSE Location  
------------------  -----  --------------------  -----------------  ----------------  ----------  ---------------  --------  --------------
AP78BC.1A6B.90F0     2     AIR-AP2802I-Q-K9      78:bc:1a:6b:90:f0  default location  J4          192.168.0.15       1       [0 ,0 ,0 ]
AP78BC.1A6B.90F8     2     AIR-AP2802I-Q-K9      78:bc:1a:6b:90:f8  default location  J4          192.168.0.14       7       [0 ,0 ,0 ]
AP78BC.1A8C.DC2E     2     AIR-AP2802I-Q-K9      78:bc:1a:8c:dc:2e  default location  J4          192.168.0.13       0       [0 ,0 ,0 ]
AP78BC.1AAD.9936     2     AIR-AP2802I-Q-K9      78:bc:1a:ad:99:36  default location  J4          192.168.0.12       1       [0 ,0 ,0 ]

config paging disable
show sysinfo
show wlan summary
show ap summary

show ap wlan 802.11a
show ap auto-rf 802.11a
show ap config 802.11a

----------
show rogue ap summary
show rogue ap detailed


---------------------
show client summary
show client detail

config paging enable
logout

COMMENT

