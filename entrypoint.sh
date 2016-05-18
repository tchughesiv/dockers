#!/bin/sh
atsdUrl=$1
atsdPort=$2

if [ -z $atsdPort ]; then
    echo usage: /opt/nmon/entrypoint.sh atsd_url atsd_port
    exit 1
fi

topRequired=""
if [ "$T" = "true" ]; then
    topRequired="-T"
fi

while true; do
    fn="/opt/nmon/$(date +%y%m%d_%H%M%S).nmon"
    pd="$(/opt/nmon/nmon -F $fn -s $s -c $c $topRequired -p)"
    { echo "nmon p:default e:`hostname` z:`date +%Z` f:`hostname`_file.nmon"; tail -f $fn -n +0 --pid=$pd; } | nc $atsdUrl $atsdPort
    if kill -0 $pd 2>/dev/null; then
        kill -9 $pd
    fi
    sleep 10
done

