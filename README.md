# FTP Storage

Allow to upload file to container by SFTP, RSYNC, SCP.

Passowrd for readonly user will be generated after container running.

## Starting

```
docker run \
    -dP \
    --name="ftp-server" \
    axibase/sftp
```

or

```
docker run \
    -dP \
    -v /srv:/home/axibase-ftp \
    --name="ftp-server" \
    axibase/sftp
```

## Get password

```
docker logs ftp-server
```

## Transfer files

```
sftp axibase-ftp@172.17.0.2:/ftp/new_statistics.csv /home/storage/new_statistics.csv
sftp /home/storage/update.xml axibase-ftp@172.17.0.2:/ftp/
```


