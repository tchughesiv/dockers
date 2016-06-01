# NMON Docker Image

## Overview

This Docker image can be used to collect snapshot statistics and system command output from at the host level in NMON format. It escapes container namespace and device isolation with `--priviliged` `--net=host`, optional `--pid=host`. 

root fs is exposed and re-mounted inside the container to provide the same system command output as on the host.

The image provides three alternatives for storing data produced by the nmon daemon:

* Container file and stdout, accessible also with `docker logs` command
* Host file
* Axibase Time Series Database (ATSD)

The advantage of collecting host-level statistics with a container as opposed to running nmon directly on the host is that this mode standartizes deployment (everything is running in containers, from images).

## Container Launch Options

| **Name** | **Description** |
|:---|:---|
|`-v /:/rootfs:ro` | Expose host's root file system / to the container on mount point `/rootfs` in read-only mode.|
|`--pid=host` | Make host's processes visible to the container, required for top process statistics collection with `T`.|
|`--net=host` | Make host's network visible to the container.|
|`--privileged` | Allow access to host's devices. | 
|`--restart=always` | Automatically restart the container on docker/machine restart.|

## Configuration Parameters

| **Name** | **Type** | **Description** |
|:---|:---|:---|
|c | integer | Number of snapshots to take between restarts. Default: 1440 (1 day @ 60 second).<br>Each restart triggers execution of system commands to collect up-to-date configuration.|
|s| integer | Snapshot interval, in seconds. Controls how frequently statistics are collected. Default: 60|
|T | boolean | Collection top process usage statistics. Default: false.<br>If enabled, `--pid=host` must be set as well as so that container has access to the list of processes on the host, instead of on the container.|

The parameters are passed to the container with environmental variables `-e`, for example:

```bash
docker run \
    ...
    -e s=60 \
    -e c=1440 \
    -e T=true \
    axibase/nmon
```

## Launch Examples


### Store data on a file in container


```bash
docker run \
    -d \
    -v /:/rootfs:ro \
    --pid=host \
    -e T=true \
    --privileged \
    --net=host \
    axibase/nmon
```

nmon output will be stored to a daily file as well as to standard out, so you can read it as usual:

```
docker logs -f nmon-cnt-collector
```

### Store data on a file in Host

Mount any directory from Docker host as nmon output folder in container:

```bash
docker run \
    -d \
    -v /:/rootfs:ro \
    -v /tmp/nmon_output:/opt/nmon/output \
    --name="nmon-host-collector" \
    --pid=host \
    -e T=true \
    --privileged \
    --net=host \
    axibase/nmon
```

All nmon output files will be stored in ```/tmp/nmon_output``` directory on Docker host.

### Store data in ATSD

```bash
docker run \
    -d \
    -v /:/rootfs:ro \
    --name="nmon-atsd-collector" \
    --pid=host \
    -e T=true \
    --privileged \
    --net=host
    axibase/nmon tcp://atsd_hostname:8081
```
