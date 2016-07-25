# Docker SFTP Container

This is a Docker container that starts a Secure FTP server and generates a [random password](entrypoint.sh) for the built-in user.

The name of the built-in user is **ftp-user**. It can be modified in Dockerfile or with an environmental variable.

The password is randomly generated when the container is started.

* [Dockerfile](Dockerfile)

## Start Container

```
docker run \
    -dP \
    --name="sftp-server" \
    axibase/sftp
```

## Obtain Password

```
docker logs sftp-server
```

## Transfer Files

```
sftp ftp-user@172.17.0.2:/ftp/file-1 /home/storage/file-1
sftp /home/storage/file-2 ftp-user@172.17.0.2:/ftp/
```


