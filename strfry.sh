#!/usr/bin/env bash
set -Eeuo pipefail

if [ ! -f "/etc/strfry.conf" ]; then
  cp /etc/strfry.conf.default /etc/strfry.conf
fi

cd /app
./strfry relay &

: ${STREAMS:=''}
[[ -z "$STREAMS" ]] && exit

for i in $(echo $STREAMS | sed "s/,/ /g")
do
  ./strfry stream wss://${i} --dir down &
  sleep 2
done
