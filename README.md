# Nmon Docker Image

## Start

The following command will start to collect data to ATSD (the ATSD server should be started and listening on specified url and port).

```
docker run -d --name="nmon-atsd-collector" axibase/nmon tcp://atsd_server:atsd_tcp_port
```

By default, nmon snapshots will be created every 60 seconds during one hour ( totally 60 snapshots ).

To specify the snapshots period and count, you can provide the following environment variables to container:

```
s - snapshots period (in seconds)
c - snapshots count
```

Example:

```
docker run -d -e s=120 -e c=30 --name="nmon-atsd-collector" axibase/nmon tcp://atsd_server:atsd_tcp_port
```

To automatically start container after docker-engine restart add `--restart=always` flag:


```
docker run -d --restart=always --name="nmon-atsd-collector" axibase/nmon tcp://atsd_server:atsd_tcp_port
```

## Collect Data from Docker-host:

To collect statistics from Dockerhost, provide the following keys to ```docker run``` command:

* ```-v /:/rootfs:ro``` - get access to host mountpoints and filesystem usage
* ```--net=host``` - get access to host network namespace
* ```--privileged``` - get access to host devices
* ```--pid=host``` - get access to host proccesses namespace
* ```-e T=true``` - while specified with `--pid=host`, order nmon to collect `top` output with program arguments

Example of command to collect data from Docker-host:

```bash
docker run \
    -d \
    -v /:/rootfs:ro \
    --name="nmon-atsd-collector" \
    --pid=host \
    -e T=true
    --privileged \
    --net=host \
    --restart=always \
    -e s=60 \
    -e c=1440 \
    axibase/nmon tcp://atsd_server:atsd_tcp_port
```
