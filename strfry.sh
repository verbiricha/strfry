#!/usr/bin/env bash
set -Eeuo pipefail

./strfry stream &

: ${STREAMS:=''}
[[ -z "$STREAMS" ]] && exit

for i in $(echo $STREAMS | sed "s/,/ /g")
do
  ./strfry stream wss://${i} --dir down &
  sleep 2
done
