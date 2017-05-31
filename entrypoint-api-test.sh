#!/bin/bash
if [ -z "$axiname" ] || [ -z "$axipass" ]; then
	echo "axiname or axipass is empty. Fail to start container."
	exit 1
fi


DISTR_HOME="/opt/atsd"
UPDATELOG="`readlink -f ${DISTR_HOME}/atsd/logs/update.log`"
STARTLOG="`readlink -f ${DISTR_HOME}/atsd/logs/start.log`"
JAVA_DISTR_HOME="/usr/lib/jvm/java-1.7.0-openjdk-amd64/"
JAR="${JAVA_DISTR_HOME}/bin/jar"
URL="https://axibase.com/public"
LATEST="$URL/atsd_ce_update_latest.htm"
LATESTTAR="${DISTR_HOME}/bin/atsd_latest.tar.gz"
revisionFile="applicationContext-common.xml"

function logger {
    echo "$1" | tee -a $UPDATELOG
}


logger "Starting ATSD update process ..."

cd ${DISTR_HOME}/bin/
uri="`curl $LATEST | grep -o 'URL=.*\"' | sed 's/URL=//g' | sed 's/"//g'`"
logger "Downloading revision $lastRevision from $URL/$uri"
curl -o $LATESTTAR $URL/$uri 2>&1 | tee -a $UPDATELOG
tar -xzvf $LATESTTAR -C ${DISTR_HOME}/bin/ >>$UPDATELOG 2>&1
newRevision="`$JAR xf ${DISTR_HOME}/bin/target/atsd-executable.jar $revisionFile; cat $revisionFile | grep "revisionNumber" | sed 's/[^0-9]//g'; rm -f $revisionFile`"
logger "Current version: $newRevision"

cd ${DISTR_HOME}/hbase/lib && mv -f atsd.jar atsd.jar_old && mv ${DISTR_HOME}/bin/target/atsd.jar ./

cd ${DISTR_HOME}/atsd/bin/ && mv -f atsd-executable.jar atsd-executable.jar_old && mv ${DISTR_HOME}/bin/target/atsd-executable.jar ./

logger "Files replaced."

#check timezone
if [ -n "$timezone" ]; then
    sed -i '/^DParams=.*/a DParams="\$DParams -Duser.timezone=$timezone"' /opt/atsd/atsd/bin/start-atsd.sh
fi

/opt/atsd/bin/atsd-dfs.sh start
/opt/atsd/bin/atsd-hbase.sh start
echo "delete 'atsd_counter', '__inst', 'type:t'" | /opt/atsd/hbase/bin/hbase shell
/opt/atsd/bin/atsd-tsd.sh start

curl -i --data "userBean.username=$axiname&userBean.password=$axipass&repeatPassword=$axipass" http://127.0.0.1:8088/login
curl -F "file=@/opt/atsd/rules.xml" -F "auto-enable=true" -F "replace=true" http://$axiname:$axipass@127.0.0.1:8088/rules/import
curl -i -u ${axiname}:${axipass} --data "options%5B0%5D.key=entity.countToUseFilter&options%5B0%5D.value=2&options%5B1%5D.key=hbase.compaction.list&options%5B1%5D.value=d+properties+message+li+tag+sql+forecast&options%5B2%5D.key=hbase.compression.type&options%5B3%5D.key=hbase.table.prefix&options%5B4%5D.key=htable.executor.corePoolSize&options%5B4%5D.value=16&options%5B5%5D.key=htable.executor.maxPoolSize&options%5B5%5D.value=32&options%5B6%5D.key=last.insert.cache.max.size&options%5B6%5D.value=100000&options%5B7%5D.key=last.insert.write.period.seconds&options%5B7%5D.value=0&options%5B8%5D.key=messages.timeToLive&options%5B9%5D.key=properties.batch.size&options%5B9%5D.value=512&options%5B10%5D.key=properties.queue.limit&options%5B10%5D.value=8192&options%5B11%5D.key=properties.queue.pool.size&options%5B11%5D.value=4&options%5B12%5D.key=properties.queue.rejection.policy&options%5B12%5D.value=BLOCK&options%5B13%5D.key=scan.caching.size&options%5B13%5D.value=2048&options%5B14%5D.key=series.batch.size&options%5B14%5D.value=1024&options%5B15%5D.key=series.queue.limit&options%5B15%5D.value=32768&options%5B16%5D.key=series.queue.pool.size&options%5B16%5D.value=4&options%5B17%5D.key=series.queue.rejection.policy&options%5B17%5D.value=BLOCK&options%5B18%5D.key=data.compaction.schedule&options%5B18%5D.value=0+0+22+*+*+*&options%5B19%5D.key=delete.schedule&options%5B19%5D.value=0+0+21+*+*+*&options%5B20%5D.key=entity.group.update.schedule&options%5B20%5D.value=0+*%2F1+*+*+*+*&options%5B21%5D.key=expired.data.removal.schedule&options%5B21%5D.value=0+0+1+*+*+*&options%5B22%5D.key=hbase.compaction.schedule&options%5B22%5D.value=0+0+1+*+*+*&options%5B23%5D.key=internal.backup.schedule&options%5B23%5D.value=0+30+23+*+*+*&options%5B24%5D.key=internal.metrics.dump.path&options%5B25%5D.key=jmx.access.file&options%5B26%5D.key=jmx.enabled&options%5B27%5D.key=jmx.host&options%5B28%5D.key=jmx.password.file&options%5B29%5D.key=jmx.port&options%5B30%5D.key=http.port&options%5B31%5D.key=https.keyManagerPassword&options%5B32%5D.key=https.keyStorePassword&options%5B33%5D.key=https.port&options%5B34%5D.key=https.trustStorePassword&options%5B35%5D.key=input.disconnect.on.error&options%5B35%5D.value=true&options%5B36%5D.key=input.port&options%5B37%5D.key=input.socket.keep-alive&options%5B38%5D.key=input.socket.receive-buffer-size&options%5B39%5D.key=pickle.port&options%5B40%5D.key=udp.input.port&options%5B41%5D.key=sql.tmp.storage.max_rows_in_memory&options%5B41%5D.value=51200&options%5B42%5D.key=cache.entity.maximum.size&options%5B42%5D.value=100000&options%5B43%5D.key=cache.metric.maximum.size&options%5B43%5D.value=50000&options%5B44%5D.key=cache.tagKey.maximum.size&options%5B44%5D.value=50000&options%5B45%5D.key=cache.tagValue.maximum.size&options%5B45%5D.value=100000&options%5B46%5D.key=entity-group.display.tags&options%5B46%5D.value=&options%5B47%5D.key=entity.display.tags&options%5B47%5D.value=environment+location&options%5B48%5D.key=metric.display.tags&options%5B48%5D.value=table+source&options%5B49%5D.key=scollector.ignore.tags&options%5B49%5D.value=environment+role&options%5B50%5D.key=api.anonymous.access.enabled&options%5B51%5D.key=delete.sleep.interval.ms&options%5B51%5D.value=2000&options%5B52%5D.key=delete.total.duration.minute&options%5B52%5D.value=60&options%5B53%5D.key=hostname&options%5B53%5D.value=`hostname`&options%5B54%5D.key=nmon.data.directory&options%5B54%5D.value=%2Ftmp%2Fatsd%2Fnmon&options%5B55%5D.key=server.url&options%5B55%5D.value=http%3A%2F%2F45d266dde38f%3A8088&apply=Save" http://127.0.0.1:8088/admin/serverproperties

while true; do
 sleep 5
done
