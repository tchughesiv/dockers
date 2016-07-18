#!/bin/bash
hostname="`hostname`"

sed -i "/<name>fs.default.name<\/name>/{n; s/<value>.*<\/value>/<value>hdfs:\/\/${hostname}:8020\/hbase<\/value>/}" /opt/${HADOOP_NAME}/etc/hadoop/core-site.xml
sed -i "/<name>hbase.rootdir<\/name>/{n; s/<value>.*<\/value>/<value>hdfs:\/\/${hostname}:8020\/hbase<\/value>/}" /opt/${HBASE_NAME}/conf/hbase-site.xml
sed -i "/<name>hbase.zookeeper.quorum<\/name>/{n; s/<value>.*<\/value>/<value>${hostname}<\/value>/}" /opt/${HBASE_NAME}/conf/hbase-site.xml

/opt/${HADOOP_NAME}/sbin/start-dfs.sh
/opt/${HBASE_NAME}/bin/start-hbase.sh
/opt/atsd/atsd/bin/start-atsd.sh

while true; do
        sleep 5
done
