#!/bin/bash


#######
##
#	Script de sincroização/backup arquivos Nexcloud com Mega - Projeto Punkzine-se
##
######


#####
#       Telegran notifications
#####
API_TOKEN=8835742153:AAGpoiU63Qxi3k08X32rwN7X5_l4XoJgP7A
CHAT_ID=8575042701

send_notification() {
    local msg="$1"
    curl -s -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" \
        -d "chat_id=$CHAT_ID" \
        --data-urlencode "text=$msg"
}


sync_nextcloud_to_mega(){
	rclone sync /home/cyx/nextcloud-docker/data/nextcloud/data/mariposasd0kaos/files/Punkzine-se/ punkzine-se:Punkzine-se
	if [ $? -eq 0 ];
	then
		send_notification "[Brutus - Punkzine-se] - Sincronia de NextCloud com Mega ok!"
	else
		send_notification "[Brutus - Punkzine-se] - Sincronia de NexCloud com Mega Falhou!!!!"
	fi
}


sync_nextcloud_to_mega
