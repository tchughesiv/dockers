#!/bin/bash

set -e

sed -i s,discard_prefix,`hostname`,g /host;

while getopts ab:c-: arg; do
  case $arg in
    - )  LONG_OPTARG="${OPTARG#*=}"
         case $OPTARG in
           atsd-url=?* )  sed -i s,atsd_url,$LONG_OPTARG,g /etc/collectd/collectd.conf; sed -i s,atsd_url,$LONG_OPTARG,g /container; sed -i s,atsd_url,$LONG_OPTARG,g /host;;
           conf=?* )  cp /$LONG_OPTARG /etc/collectd/collectd.conf;;
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done

exec /usr/sbin/collectd -C /etc/collectd/collectd.conf -f

