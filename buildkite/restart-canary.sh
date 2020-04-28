#!/bin/bash

export PATH="$PATH:/root/bin"

ssh root@web01 "bin/bounce-apache >/dev/null &"

sleep 15

restart_ok () {
    echo "Canary restarted OK!"
    exit 0
}

curl -s web01/admin/healthy | grep -q 'status=ok' && restart_ok

echo "Canary failed startup!"

tail -100 /var/log/apache2/error.log

exit 1
