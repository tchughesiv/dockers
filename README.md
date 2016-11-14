# Collectd Docker Image

This image provides a Dockerized collectd configuration to gather operating system statistics from the underlying Docker host instead of a container where it's launched.

The collectd agent started within the container is automatically configured to send metrics into your Axibase Time Series Database instance using the [write_atsd](https://github.com/axibase/atsd-collectd-plugin) plugin. The target ATSD instance is specified in the `--atsd-url` argument.

## Prepare Image

### Build Image 

* Download [Dockerfile](Dockerfile) to a Docker host connected to hub.docker.com

* Build image

```
docker build -t axibase/collectd .
```

### Download Image

* Download a pre-built image file from [axibase.com](https://axibase.com/public/docker-axibase-collectd.tar.gz)

* Import the image into the Docker host

```
docker load < docker-axibase-collectd.tar.gz
```

## Start Container

### Basic Configuration

* Start Docker container

```ls
docker run -d -v /:/rootfs:ro --pid=host --net=host \
    --name=collectd axibase/collectd \
    --atsd-url=tcp://atsd_host:tcp_port
```

### `lvs` Configuration

> This configuration gathers data from the `lvs` command and therefore requires additional privileges.

```ls
docker run -d -v /:/rootfs:ro --privileged=true \
    --pid=host --net=host \
    --name=collectd axibase/collectd \
    --atsd-url=tcp://atsd_host:tcp_port \
    --lvs
```

### Credits

* [Carles Amigó](https://github.com/fr3nd/docker-collectd) for the idea to re-mount rootfs.
