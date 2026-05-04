#!/bin/sh


####
#       Script para dar um BOOST no xmrig quando servidor estiver ocioso
#
####

MODE=$1
JSON_FILE='/home/nero/xmrig/xmrig/build/config.json'

if [ $MODE = 'fast' ]; then
        sed -i 's/"mode": "light"/"mode": "fast"/' $JSON_FILE
        sed -i 's/"init": 600/"init": 800/' $JSON_FILE
        systemctl stop netdata;
        systemctl stop xmrig;
        sync && echo 3 | tee /proc/sys/vm/drop_caches
        sysctl -w vm.nr_hugepages=800
        sleep 5
        nice -n -10 /home/nero/xmrig/xmrig/build/xmrig -c $JSON_FILE
elif [ $MODE = 'light' ]; then
        sed -i 's/"mode": "fast"/"mode": "light"/' $JSON_FILE
        sed -i 's/"init": 800/"init": 600/' $JSON_FILE
        systemctl start netdata;
        systemctl start xmrig;
else
        echo "Use ./script.sh fast ou light"
fi
