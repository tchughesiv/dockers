#!/bin/sh

#mount distribution info files
cd /rootfs
find etc/ -maxdepth 1 -name "*-release" -exec mount -o bind /rootfs/{} /{} 2>/dev/null \;

#check output format
atsdUrl=""
atsdPort=""
stdout=false
if [ -z $1 ]; then
    stdout=true
else
    atsdUrl=$(echo "$1" | awk -F: '{print $2}' | cut -c 3-)
    atsdPort=$(echo "$1" | awk -F: '{print $3}')
fi


#check extra agruments
topRequired=""
if [ "$T" = "true" ]; then
    topRequired="-T"
fi


while true; do
    fn="/opt/nmon/$(date +%y%m%d_%H%M%S).nmon"
    pd="$(/opt/nmon/nmon -F $fn -s $s -c $c $topRequired -p)"
    if $stdout; then
        tail -f $fn -n +0 --pid=$pd
    else
        { echo "nmon p:default e:`hostname` z:`date +%Z` f:`hostname`_file.nmon"; tail -f $fn -n +0 --pid=$pd; } | nc $atsdUrl $atsdPort
    fi
    if kill -0 $pd 2>/dev/null; then
        kill -9 $pd
    fi
    sleep 10
done

