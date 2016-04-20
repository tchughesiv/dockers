# Nmon Docker Image

## Start

The following command will start to collect data to ATSD (the ATSD server should be started and listening on specified url and port).

```
docker run -d --name="nmon-atsd-collector" axibase/nmon atsd_server atsd_tcp_port
```

By default, nmon snapshots will be created every 60 seconds during one hour ( totally 60 snapshots ).

To specify the snapshots period and count, you can provide the following environment variables to container:

```
s - snapshots period (in seconds)
c - snapshots count
```

Example:

```
docker run -d -e s=120 -e c=30 --name="nmon-atsd-collector" axibase/nmon atsd_server atsd_tcp_port
```

To automatically start container after docker-engine restart add `--restart=always` flag:


```
docker run -d --restart=always --name="nmon-atsd-collector" axibase/nmon atsd_server atsd_tcp_port
```

