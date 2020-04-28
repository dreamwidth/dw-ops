#!/bin/bash

export PATH="$PATH:/root/bin"

for HOST in $(hosts-web | grep -v web01); do
    ssh root@$HOST "bin/bounce-apache >/dev/null &"

    sleep 15

    restart_ok () {
        echo "$HOST restarted OK!"
        exit 0
    }

    curl -s $HOST/admin/healthy | grep -q 'status=ok' && restart_ok

    echo "$HOST failed startup!"
    echo
    ssh root@$HOST "tail -100 /var/log/apache2/error.log"
    echo

    exit 1
done
