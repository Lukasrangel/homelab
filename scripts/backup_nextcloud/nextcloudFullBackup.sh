#!/bin/bash


#########
##
#	Script de Backup do Nextcloud Punkzine-Se!
##
########


######


# bot api telegram
API_TOKEN=<yout id token bot>
CHAT_ID=<Your chat ID>

send_notification() {
    local msg="$1"
    curl -s -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" \
        -d "chat_id=$CHAT_ID" \
        --data-urlencode "text=$msg"
}



LOCAL_BKP=/root/backups/nextcloud/nextcloud-$(date +%d-%m-%Y)
NEXTCLOUD_FILES=YOUR_NEXTCLOUD_STORAGE_FILES

mkdir -p ${LOCAL_BKP}

mysql_bkp(){
	docker exec nextcloud-db mysqldump -u nextcloud -p"PASS" nextcloud > ${LOCAL_BKP}/nextcloud-db.sql

}

files_bkp(){
	docker exec -u www-data -it nextcloud-app php occ maintenance:mode --on
	rsync -avx ${NEXTCLOUD_FILES}  ${LOCAL_BKP}/files
	docker exec -u www-data -it nextcloud-app php occ maintenance:mode --off
}


encrypt(){
	sudo tar -czvf /root/backups/nextcloud/nextcloud-full-backup-$(date +%d-%m-%Y).tar.gz -C ${LOCAL_BKP}/ .
	rm -rf ${LOCAL_BKP}
}

bkp_rotate(){
	find /root/backups/nextcloud/ -type f -name "*.tar.gz" -mtime +20 -delete
}


bkp_to_cloud(){
	if rclone copy /root/backups/nextcloud/nextcloud-full-backup-$(date +%d-%m-%Y).tar.gz punkzine-se: ; then
		/usr/bin/rclone delete punkzine-se: --min-age 7d  --include "*.tar.gz"
		send_notification "[NextCLoud] Backup to Cloud Sussesfull"
	else
		send_notification "[Nextcloud] Backup Fail!!!"	
	fi
}

main(){
	mysql_bkp
	files_bkp
	encrypt
	bkp_rotate
	bkp_to_cloud
}



main
