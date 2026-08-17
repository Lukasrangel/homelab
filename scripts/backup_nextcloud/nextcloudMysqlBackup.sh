#!/bin/bash


#########
##
#	Script de Backup do Nextcloud Punkzine-Se!
##
########


######


# bot api telegram
API_TOKEN=<your token id
CHAT_ID=<your chat id>

send_notification() {
    local msg="$1"
    curl -s -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" \
        -d "chat_id=$CHAT_ID" \
        --data-urlencode "text=$msg"
}



LOCAL_BKP=/root/backups/nextcloud
mkdir -p ${LOCAL_BKP}

mysql_bkp(){
	docker exec nextcloud-db mysqldump -u nextcloud -p"mysql_pass" nextcloud > ${LOCAL_BKP}/nextcloud-db-$(date +%d-%m-%Y).sql

}


bkp_rotate(){
	find /root/backups/nextcloud/ -type f -name "*.sql" -mtime +30 -delete
}


bkp_to_cloud(){
	if /usr/bin/rclone copy ${LOCAL_BKP}/nextcloud-db-$(date +%d-%m-%Y).sql punkzine-se: ; then
		/usr/bin/rclone delete punkzine-se: --min-age 20d  --include "*.sql"
		send_notification "[NextCloud MYSQL] Backup Mysql to Cloud Sussesfull"
	else
		send_notification "[Nextcloud MYSQL] Backup Fail!!!"	
	fi
}

main(){
	mysql_bkp
	bkp_rotate
	bkp_to_cloud
}



main
