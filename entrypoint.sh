#!/bin/bash

password="$RANDOM-$RANDOM-$RANDOM"
echo $password | tee /opt/$ftpuser-password

echo "$ftpuser:$password" | chpasswd

vsftpd

