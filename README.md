# Nmon Docker Image.

## Start

The following command will start to collect data to ATSD.

```
docker run -d axibase/nmon atsd_server atsd_tcp_port
```

The nmon snapshots will be created every 60 seconds during one hour ( totaly 60 snapshots ).

To specify the snapshots period and count, you can provide the following environment variables to container:

```
s - snapshots period
c - snapshots count
```

Example:

```
docker run -d -e s=120 c=30 axibase/nmon atsd_server atsd_tcp_port
```


