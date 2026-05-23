#!/bin/bash


#######
##
##      Script para monitoramento da temperatura,  se ultrapassar temperatura para o miner
##
######


CPU_TEMP=$(sensors | grep -m 1 'Package id 0' | awk '{print substr($4, 2, 4)}'  | cut -d. -f 1)
CPU_TEMP_LIMIT=64
CPU_TEMP_FINE=46

#####
#       Telegran notifications
#####
API_TOKEN="<your_bot_token"
CHAT_ID="<your_chat_id>"

send_notification() {
    local msg="$1"
    curl -s -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" \
        -d "chat_id=$CHAT_ID" \
        --data-urlencode "text=$msg"
}



if [ "$CPU_TEMP" -gt "$CPU_TEMP_LIMIT" ]; then
        systemctl stop xmrig
        echo " $(date '+%d/%m/%Y %H:%M:%S') CPU TEMP > $CPU_TEMP_LIMIT STOP MINER!!" >> /var/log/xmrig
	send_notification "[Artemis Alert] $(date '+%d/%m/%Y %H:%M:%S') CPU TEMP > $CPU_TEMP_LIMIT STOP MINER!!"
        exit 1
elif [ "$CPU_TEMP" -le "$CPU_TEMP_FINE" ]; then
        systemctl start xmrig
        echo "$(date '+%d/%m/%Y %H:%M:%S') CPU TEMP ESTABLISHED IN $CPU_TEMP_FINE, RESTARTING THE PROCESS" >> /var/log/xmrig
        send_notification "[Artemis Alert] $(date '+%d/%m/%Y %H:%M:%S') CPU TEMP ESTABLISHED IN $CPU_TEMP_FINE, RESTARTING THE PROCESS"
	exit 0
fi
