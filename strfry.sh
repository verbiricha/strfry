#!/usr/bin/env bash
set -Eeuo pipefail

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

if [ ! -f "/etc/strfry.conf" ]; then
  cp /etc/strfry.conf.default /etc/strfry.conf
fi

cd /app
./strfry relay &
PID=$!

: ${STREAMS:=''}
if [[ ! -z "$STREAMS" ]]; then

  for i in $(echo $STREAMS | sed "s/,/ /g")
  do
    ./strfry stream wss://${i} --dir down 2> /dev/null &
    sleep 2
  done
  
fi

wait $PID
