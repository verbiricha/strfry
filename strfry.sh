#!/usr/bin/env bash
set -Eeuo pipefail

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

if [ ! -f "/etc/strfry.conf" ]; then
    cp /etc/strfry.conf.default /etc/strfry.conf
fi

cd /app
./strfry relay &
PID=$!

: ${ROUTER:=''}
: ${STREAMS:=''}

if [ -f "${ROUTER}" ]; then
    sleep 2
    ./strfry router "${ROUTER}" &
fi

if [[ "${ROUTER}" == [Yy1]* ]]; then
    sleep 2
    ./strfry router /etc/strfry-router.conf &
fi

for i in $(echo $STREAMS | sed "s/,/ /g")
do
    if [[ -n "$i" ]]; then
        sleep 2
        ./strfry stream wss://$i --dir down 2> /dev/null &
    fi
done

wait $PID
