#!/bin/bash

export PATH="$PATH:/root/bin"

echo "Restarting canary host..."
ssh root@web01 "bin/bounce-apache >/dev/null &"

sleep 15

restart_ok () {
    echo "Canary restarted OK!"
    exit 0
}

curl -s web01/admin/healthy | grep -q 'status=ok' && restart_ok

echo "Canary failed startup!"
echo
ssh root@web01 "tail -100 /var/log/apache2/error.log"
echo

exit 1
