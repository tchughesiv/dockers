#!/bin/bash
axiname="axibase"
axipass="axibase"
cd /home/axibase
/entrypoint-atsd.sh $axiname $axipass >/dev/null 2>&1 &
git clone -b master https://github.com/axibase/atsd-api-test
while ! curl localhost:8088 >/dev/null 2>&1; do echo "waiting to start ATSD server ..."; sleep 3; done
cd atsd-api-test
mvn clean test -Dmaven.test.failure.ignore=false -DserverName="localhost" -Dlogin=$axiname -Dpassword=$axipass 

