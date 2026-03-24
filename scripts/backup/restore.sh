#!/bin/bash

#global resources
BACKUP_FILE=$1
TMP_DIR="/tmp/restore_$(date +%s)"
LOG_FILE="./restore.log"


# send all outputs to file
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Iniciando restore..."


if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup não encontrado"
    exit 1
fi

mkdir -p "$TMP_DIR"
if ! gpg -d  "$BACKUP_FILE" | tar -xzf - -C "$TMP_DIR"; then
    echo "Erro ao descriptografar ou extrair arquivo"
    exit 1
fi


log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Restore por blocos

#retore do var/www
var(){
    echo "Restaurando /var/www"
    rm -rf /var/www/*
    if cp -r "$TMP_DIR/var/www/." /var/www/; then
        log "Restaurando /var/www/... OK!"
    fi
}


#restore home
home() {
    echo "Restaurando home"
    if cp -r "$TMP_DIR/home/." /home/; then
        log "Restaurando /home... OK!"
    else    
        log "Erro ao restaurar /home"
    fi
}


#restore root()
root() {
    echo "Restaurando /root"
    if cp -r "$TMP_DIR/root/." /root/; then
        log "Restaurando /root... OK!"
    else
        log "Erro ao restaurar /root"
    fi

}


opt() {
    echo "Restaurando /opt"
    rm -rf /opt/*
    if cp -r "$TMP_DIR/opt/" /opt/; then
        log "Restaurando /opt... OK!"
    else
        log "Erro ao restaurar /opt"
    fi
}


etc(){
    echo "Restaurando /etc"
    #rm -rf /etc/*
    if cp -r "$TMP_DIR/etc/" /etc/; then
        log "Restaurando /etc... OK!"
    else
        log "Erro ao restaurar /etc"
    fi
}

main() {
#    var
#    home
#    root
#    opt
#    etc
    rm -rf "$TMP_DIR"
}

main




