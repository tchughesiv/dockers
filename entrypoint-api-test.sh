#!/bin/bash
atsd_user="axibase"
atsd_password="axibase"
atsd_host="localhost"
atsd_http_port=8088


function atsd_is_available {
    local response_status=$(curl --user ${atsd_user}:${atsd_password} --write-out %{http_code} --silent --output /dev/null http://${atsd_host}:${atsd_http_port}/version)
    if [[ ${response_status} == 200 ]]; then
        return 0;
    else
        return 1;
    fi
}

cd /home/axibase
/entrypoint-atsd.sh ${atsd_user} ${atsd_password} >/dev/null 2>&1 &
# Clone and run tests
git clone -b master https://github.com/axibase/atsd-api-test
# Wait for atsd
while ! atsd_is_available; do
  echo "waiting to start atsd server ...";
  sleep 3;
done
# Set last.write.insert property to 0
curl -i -u ${atsd_user}:${atsd_password} --data "options%5B0%5D.key=entity.countToUseFilter&options%5B0%5D.value=2&options%5B1%5D.key=hbase.compaction.list&options%5B1%5D.value=d+properties+message+li+tag+sql+forecast&options%5B2%5D.key=hbase.compression.type&options%5B3%5D.key=hbase.table.prefix&options%5B4%5D.key=htable.executor.corePoolSize&options%5B4%5D.value=16&options%5B5%5D.key=htable.executor.maxPoolSize&options%5B5%5D.value=32&options%5B6%5D.key=last.insert.cache.max.size&options%5B6%5D.value=100000&options%5B7%5D.key=last.insert.write.period.seconds&options%5B7%5D.value=0&options%5B8%5D.key=messages.timeToLive&options%5B9%5D.key=properties.batch.size&options%5B9%5D.value=512&options%5B10%5D.key=properties.queue.limit&options%5B10%5D.value=8192&options%5B11%5D.key=properties.queue.pool.size&options%5B11%5D.value=4&options%5B12%5D.key=properties.queue.rejection.policy&options%5B12%5D.value=BLOCK&options%5B13%5D.key=scan.caching.size&options%5B13%5D.value=2048&options%5B14%5D.key=series.batch.size&options%5B14%5D.value=1024&options%5B15%5D.key=series.queue.limit&options%5B15%5D.value=32768&options%5B16%5D.key=series.queue.pool.size&options%5B16%5D.value=4&options%5B17%5D.key=series.queue.rejection.policy&options%5B17%5D.value=BLOCK&options%5B18%5D.key=data.compaction.schedule&options%5B18%5D.value=0+0+22+*+*+*&options%5B19%5D.key=delete.schedule&options%5B19%5D.value=0+0+21+*+*+*&options%5B20%5D.key=entity.group.update.schedule&options%5B20%5D.value=0+*%2F1+*+*+*+*&options%5B21%5D.key=expired.data.removal.schedule&options%5B21%5D.value=0+0+1+*+*+*&options%5B22%5D.key=hbase.compaction.schedule&options%5B22%5D.value=0+0+1+*+*+*&options%5B23%5D.key=internal.backup.schedule&options%5B23%5D.value=0+30+23+*+*+*&options%5B24%5D.key=internal.metrics.dump.path&options%5B25%5D.key=jmx.access.file&options%5B26%5D.key=jmx.enabled&options%5B27%5D.key=jmx.host&options%5B28%5D.key=jmx.password.file&options%5B29%5D.key=jmx.port&options%5B30%5D.key=http.port&options%5B31%5D.key=https.keyManagerPassword&options%5B32%5D.key=https.keyStorePassword&options%5B33%5D.key=https.port&options%5B34%5D.key=https.trustStorePassword&options%5B35%5D.key=input.disconnect.on.error&options%5B35%5D.value=true&options%5B36%5D.key=input.port&options%5B37%5D.key=input.socket.keep-alive&options%5B38%5D.key=input.socket.receive-buffer-size&options%5B39%5D.key=pickle.port&options%5B40%5D.key=udp.input.port&options%5B41%5D.key=sql.tmp.storage.max_rows_in_memory&options%5B41%5D.value=51200&options%5B42%5D.key=cache.entity.maximum.size&options%5B42%5D.value=100000&options%5B43%5D.key=cache.metric.maximum.size&options%5B43%5D.value=50000&options%5B44%5D.key=cache.tagKey.maximum.size&options%5B44%5D.value=50000&options%5B45%5D.key=cache.tagValue.maximum.size&options%5B45%5D.value=100000&options%5B46%5D.key=alert.file.maxBackupIndex&options%5B46%5D.value=10&options%5B47%5D.key=alert.file.maxSize&options%5B47%5D.value=5242880&options%5B48%5D.key=alert.file.path&options%5B48%5D.value=%2Ftmp%2Fatsd%2Falert.log&options%5B49%5D.key=alert.log.enabled&options%5B49%5D.value=true&options%5B50%5D.key=entity-group.display.tags&options%5B50%5D.value=&options%5B51%5D.key=entity.display.tags&options%5B51%5D.value=environment+location&options%5B52%5D.key=metric.display.tags&options%5B52%5D.value=table+source&options%5B53%5D.key=scollector.ignore.tags&options%5B53%5D.value=environment+role&options%5B54%5D.key=api.anonymous.access.enabled&options%5B55%5D.key=delete.sleep.interval.ms&options%5B55%5D.value=2000&options%5B56%5D.key=delete.total.duration.minute&options%5B56%5D.value=60&options%5B57%5D.key=hostname&options%5B57%5D.value=`hostname`&options%5B58%5D.key=nmon.data.directory&options%5B58%5D.value=%2Ftmp%2Fatsd%2Fnmon&options%5B59%5D.key=server.url&options%5B59%5D.value=http%3A%2F%2F45d266dde38f%3A8088&apply=Save" http://localhost:8088/admin/serverproperties > /dev/null 2>&1
cd atsd-api-test
# Run tests
mvn '-Dtest=!PropertyDeleteTest#*ExactFalse, !MessageQueryStatsTest' clean test -Dmaven.test.failure.ignore=false -DserverName=${atsd_host} -Dlogin=${atsd_user} -Dpassword=${atsd_password}

