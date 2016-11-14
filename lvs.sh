#!/usr/bin/env bash

HOSTNAME="${COLLECTD_HOSTNAME:-localhost}"
INTERVAL="${COLLECTD_INTERVAL:-10}"
re='^-?[0-9]+([.][0-9]+)?$'

while sleep "$INTERVAL"; do
  while IFS=',' read -r f1 f2 f3 f4 f5 f6 f7 f8 f9
  do
     f1=$(echo ${f1})
     f2=$(echo ${f2})
     f4=${f4::-1}
     f7=$(echo ${f7})
     f8=$(echo ${f8})
     if [[ $f4 =~ $re ]]; then
        echo "PUTVAL $HOSTNAME/exec-lvs.lsize/gauge-volume_group=$f2;logical_volume=$f1 N:$f4";
     fi
     if [[ $f7 =~ $re ]]; then
        echo "PUTVAL $HOSTNAME/exec-lvs.data%/gauge-volume_group=$f2;logical_volume=$f1 N:$f7";
     fi
     if [[ $f8 =~ $re ]]; then
        echo "PUTVAL $HOSTNAME/exec-lvs.meta%/gauge-volume_group=$f2;logical_volume=$f1 N:$f8";
     fi
  done < <(sudo lvs --separator=, --units B)
done