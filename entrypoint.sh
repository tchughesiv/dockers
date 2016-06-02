#!/bin/bash

password="$RANDOM-$RANDOM-$RANDOM"
echo $password | tee /opt/$ftpuser-password

echo "$ftpuser:$password" | chpasswd

service ssh start >/dev/null 2>&1
vsftpd

