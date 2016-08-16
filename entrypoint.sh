#!/bin/bash
if [ -z "$axiname" ] || [ -z "$axipass" ]; then
	echo "axiname or axipass is empty. Fail to start container."
	exit 1
fi


DISTR_HOME="/opt/atsd"
ATSD_START="`readlink -f ${DISTR_HOME}/atsd/bin/start-atsd.sh`"
allControl="${DISTR_HOME}/bin/atsd-all.sh"
tsdControl="${DISTR_HOME}/bin/atsd-tsd.sh"
hbaseControl="${DISTR_HOME}/bin/atsd-hbase.sh"
UPDATELOG="`readlink -f ${DISTR_HOME}/atsd/logs/update.log`"
STARTLOG="`readlink -f ${DISTR_HOME}/atsd/logs/start.log`"
JAVA_DISTR_HOME="/usr/lib/jvm/java-1.7.0-openjdk-amd64/"
JAR="${JAVA_DISTR_HOME}/bin/jar"
URL="http://axibase.com/public"
LATEST="$URL/atsd_ce_update_latest.htm"
LATESTTAR="${DISTR_HOME}/bin/atsd_latest.tar.gz"
atsdExecutable="${DISTR_HOME}/atsd/bin/atsd-executable.jar"
revisionFile="applicationContext-common.xml"
autoconfirm="true"
autoatsd="true"

function logger {
    echo "$1" | tee -a $UPDATELOG
}


logger "Checking curl ..."
if ! which curl >/dev/null; then
    logger "Curl is not installed. Please install it manually before continuing the update process."
    exit 1
fi

logger "Starting ATSD update process ..."
currentRevision=0
lastRevision=0

cd ${DISTR_HOME}/bin/
currentRevision="`$JAR xf $atsdExecutable $revisionFile; cat $revisionFile | grep "revisionNumber" | sed 's/[^0-9]//g'; rm -f $revisionFile`"
if [ "$currentRevision" = "" ]; then
    logger "Can't define current version."
    exit 1
fi
logger "Current version: $currentRevision"

uri="`curl $LATEST | grep -o 'URL=.*\"' | sed 's/URL=//g' | sed 's/"//g'`"
lastRevision="`echo $uri | sed 's/[^0-9]//g'`"
if [ "$lastRevision" = "" ]; then
    logger "Can't define latest version."
    exit 1
fi
logger "Latest version: $lastRevision"


logger "Downloading revision $lastRevision from $URL/$uri"
curl -o $LATESTTAR $URL/$uri 2>&1 | tee -a $UPDATELOG
logger "ATSD revision $lastRevision downloaded to `readlink -f $LATESTTAR`"

logger "Extracting ATSD ..."
tar -xzvf $LATESTTAR -C ${DISTR_HOME}/bin/ >>$UPDATELOG 2>&1
logger "ATSD extracted."
rm -f $LATESTTAR
newRevision="`$JAR xf ${DISTR_HOME}/bin/target/atsd-executable.jar $revisionFile; cat $revisionFile | grep "revisionNumber" | sed 's/[^0-9]//g'; rm -f $revisionFile`"
if [ "$newRevision" = "" ]; then
    logger "Can't define new version from jar file. Update stopped."
    exit 1
fi
logger "Current version: $newRevision"



logger "Replacing files ..."

cd ${DISTR_HOME}/hbase/lib
mv -f atsd.jar atsd.jar_old
mv ${DISTR_HOME}/bin/target/atsd.jar ./

cd ${DISTR_HOME}/atsd/bin/
mv -f atsd-executable.jar atsd-executable.jar_old
mv ${DISTR_HOME}/bin/target/atsd-executable.jar ./

rmdir ${DISTR_HOME}/bin/target

logger "Files replaced."
#/opt/atsd/install_user.sh

#check timezone
if [ -n "$timezone" ]; then
    sed -i '/^DParams=.*/a DParams="\$DParams -Duser.timezone=$timezone"' /opt/atsd/atsd/bin/start-atsd.sh
fi

/opt/atsd/bin/atsd-all.sh start

curl -i --data "userBean.username=$axiname&userBean.password=$axipass&repeatPassword=$axipass" http://127.0.0.1:8088/login
curl -F "file=@/opt/atsd/rules.xml" -F "auto-enable=true" -F "replace=true" http://$axiname:$axipass@127.0.0.1:8088/rules/import

while true; do
 sleep 5
done
