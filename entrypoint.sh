#!/bin/bash

set -e

while getopts ab:c-: arg; do
  case $arg in
    - )  LONG_OPTARG="${OPTARG#*=}"
         case $OPTARG in
           atsd-url=?* )  cp /collectd.conf /etc/collectd/collectd.conf; sed -i s,atsd_url,$LONG_OPTARG,g /etc/collectd/collectd.conf;;
           host=?* )  sed -i s,localhost,$LONG_OPTARG,g /etc/collectd/collectd.conf;;
           port=?* )  sed -i s,2003,$LONG_OPTARG,g /etc/collectd/collectd.conf;;
           protocol=?* )  sed -i s,tcp,$LONG_OPTARG,g /etc/collectd/collectd.conf;;
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done

exec /usr/sbin/collectd -C /etc/collectd/collectd.conf -f

