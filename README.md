# Docker SFTP Container

This is a Docker container that starts a Secure FTP server and generates a random password for the built-in user.

The name of the built-in user is `axibase-ftp` and can be modified in Dockerfile.

The password is randomly generated when the container is launched.

## Start Container

```
docker run \
    -dP \
    --name="sftp-server" \
    axibase/sftp
```

or

```
docker run \
    -dP \
    -v /srv:/home/axibase-ftp \
    --name="sftp-server" \
    axibase/sftp
```

## Obtain Password

```
docker logs sftp-server
```

## Transfer Files

```
sftp axibase-ftp@172.17.0.2:/ftp/file-1 /home/storage/file-1
sftp /home/storage/file-2 axibase-ftp@172.17.0.2:/ftp/
```


