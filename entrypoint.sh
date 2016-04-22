#!/bin/bash

set -e

while getopts ab:c-: arg; do
  case $arg in
    - )  LONG_OPTARG="${OPTARG#*=}"
         case $OPTARG in
           atsd-url=?* )  sed -i s,atsd_url,$LONG_OPTARG,g /etc/collectd/collectd.conf;;
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done

exec /usr/sbin/collectd -C /etc/collectd/collectd.conf -f

