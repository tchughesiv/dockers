#!/bin/bash
if [ -w /etc/passwd ]; then 
  USER_ID=$(id -u)
  id ${USER_ID} &> /dev/null
  if [ $? -ne 0 ]; then
    export HOME=/opt/atsd
    sed "s@axibase:x:\${USER_ID}:@axibase:x:${USER_ID}:@g" /etc/passwd.template > /etc/passwd
  fi
fi
exec "$@"
