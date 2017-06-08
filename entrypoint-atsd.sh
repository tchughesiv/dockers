#!/bin/bash
cd /home/axibase/

axiname="$1"
axipass="$2"
if [ -z "$axiname" ] || [ -z "$axipass" ]; then
	echo "axiname or axipass is empty. Fail to start container."
	exit 1
fi

curl -O https://axibase.com/public/atsd_ee_hbase_${version}.tar.gz 
tar -xzf atsd_ee_hbase_${version}.tar.gz
cp atsd/hbase/lib/atsd-hbase.*.jar ./hbase-${version}/lib/

/entrypoint-hbase.sh > /dev/null &
sleep 10 #make sure hbase is manage to start
/home/axibase/atsd/atsd/bin/start-atsd.sh
while ! curl localhost:8088 >/dev/null 2>&1; do echo "waiting to start ATSD server ..."; sleep 3; done

curl -i --data "userBean.username=$axiname&userBean.password=$axipass&repeatPassword=$axipass" http://127.0.0.1:8088/login
curl -F "file=@/home/axibase/rules.xml" -F "auto-enable=true" -F "replace=true" http://$axiname:$axipass@127.0.0.1:8088/rules/import

tail -f /home/axibase/atsd/atsd/logs/atsd.log
