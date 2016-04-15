#!/bin/bash
hostname="`hostname`"

sed -i "/<name>hbase.rootdir<\/name>/{n; s/<value>.*<\/value>/<value>hdfs:\/\/${hostname}:8020\/hbase<\/value>/}" /opt/hbase/conf/hbase-site.xml
sed -i "/<name>hbase.zookeeper.quorum<\/name>/{n; s/<value>.*<\/value>/<value>${hostname}<\/value>/}" /opt/hbase/conf/hbase-site.xml
sed -i "/<name>fs.default.name<\/name>/{n; s/<value>.*<\/value>/<value>hdfs:\/\/${hostname}:8020\/hbase<\/value>/}" /opt/hadoop/etc/hadoop/core-site.xml

/opt/hadoop/sbin/start-dfs.sh
/opt/hbase/bin/start-hbase.sh
while true; do
sleep 5
done

