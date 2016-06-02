#!/bin/bash

password="$RANDOM-$RANDOM-$RANDOM"
echo $password | tee /opt/$ftpuser-password

echo "$ftpuser:$password" | chpasswd

service ssh start 2>/dev/null
vsftpd

