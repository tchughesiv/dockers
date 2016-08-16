#!/bin/sh
/home/axibase/hbase-${version}/bin/start-hbase.sh
hbase_log="/home/axibase/hbase-${version}/logs/hbase-*master*.log"
tail -f ${hbase_log}
