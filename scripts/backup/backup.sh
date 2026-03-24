#!/bin/bash


#####################################
#  Script para backup metodologia 3-2-1
####################################


###path to backup
backup_dirs="/home /root /opt/pihole /etc"

#log file
log_file="/var/log/backup_service.log"

#Storages
local_storage="/backup"
external_storage="/mnt/backup"
cloud_storage="mega:"


#UUID of second device
uuid=$(blkid /dev/sdb1 -sUUID -ovalue)


#names of file
date_format=$(date "+%d-%m-%Y")
final_name="artemisbkp_$date_format.tar.gz"




####################
#Fist copy and backup file
####################
bkp_local(){
        if tar -czSp $backup_dirs | gpg --batch --yes --passphrase-file /root/.gpg-passphrase -c -o "$local_storage/$final_name.gpg";
        then
                printf "[$date_format] LOCAL STORAGE BACKUP SUCCESSFULL!!! \n" >> $log_file
        else
                printf "[$date_format] LOCAL STORAGE FAIL IMPOSSIBLE TO CONTINUE... ABORTIN BACKUP ROUTINE!! \n" >> $log_file
        exit 1;
        fi
}


#############################
# Verifica external storage e copy pra lá
#############################
bkp_external(){
        if ! mountpoint -q $external_storage;
        then
                printf "[$date_format] EXTERNAL STORAGE NOT MOUNTED, TRY TO SET UP... \n" >> $log_file
                if mount -U $uuid $external_storage;
                then
                        printf "[$date_format] EXTERNAL STORAGE MOUNTED IN $external_storage \n" >> $log_file
                        if cp "$local_storage/$final_name.gpg" "$external_storage/$final_name.gpg";
                        then
                                printf "[$date_format] SECONDARY IN $external_storage BACKUP SUCESSFULY!! \n" >> $log_file
                        else
                                printf "[$date_format] SECONDARY BACKUP FAILED! UNABLE TO COPY BKP FILE!! \n" >> $log_file

                        fi
                else
                        printf "[$date_format] SECONDARY BACKUP FAILED, UNABLE TO MOUNT FYLESYSTEM!! \n" >> $log_file
                fi
        else
                if cp "$local_storage/$final_name.gpg" "$external_storage/$final_name.gpg";
                then
                        printf "[$date_format] SECONDARY IN $external_storage BACKUP SUCESSFULY!! \n" >> $log_file
                else
                printf "[$date_format] SECONDARY BACKUP FAILED! UNABLE TO COPY BKP FILE!! \n" >> $log_file
                fi

        fi
}

#################################
# Check internet connection and upload bkp to drive
bkp_cloud(){
        if ping 1.1.1.1 -c 2 > /dev/null 2>&1
        then
                rclone copy "$local_storage/$final_name.gpg" $cloud_storage
                if [ $? -eq 0 ];
                then
                        printf "[$date_format] THIRD STORAGE - TO CLOUD - SUCESSFULL!!! \n" >> $log_file
                else
                        printf "[$date_format] UPLOAD TO CLOUD FAIL!!! \n" >> $log_file
                fi
        fi
}




##main
main(){
        bkp_local
        bkp_external
        bkp_cloud
}


main


