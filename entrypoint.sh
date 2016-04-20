#!/bin/sh
atsdUrl=$1
atsdPort=$2

if [ -z $atsdPort ]; then
    echo usage: /opt/nmon/entrypoint.sh atsd_url atsd_port
    exit 1
fi

while true; do
    fn="/opt/nmon/$(date +%y%m%d_%H%M).nmon"
    pd="$(/opt/nmon/nmon -F $fn -s $s -c $c -T -p)"
    { echo "nmon p:default e:`hostname` f:`hostname`_file.nmon"; tail -f $fn --pid=$pd; } | nc $atsdUrl $atsdPort
done

