#!/bin/bash

export PATH="$PATH:/root/bin"

for HOST in $(hosts-web | grep -v web01); do
    echo "Restarting $host..."
    ssh root@$HOST "bin/bounce-apache >/dev/null &"

    sleep 15

    if curl -s $HOST/admin/healthy | grep -q 'status=ok'; then
        echo " * $HOST restarted!"
    else
        echo " * $HOST failed startup!"
        echo
        ssh root@$HOST "tail -100 /var/log/apache2/error.log"
        echo
        exit 1
    fi
done
