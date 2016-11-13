## Collectd Docker Image

This image collects statistics from Docker host (engine) and not from a container where it's launched.

### Send Statistics to Axibase Time Series Database

* Build image:

```
docker build -t axibase/collectd .
```

* Run Docker container in simple mode:

```ls
docker run -d -v /:/rootfs:ro --pid=host --net=host \
    --name=collectd axibase/collectd \
    --atsd-url=tcp://atsd_host:tcp_port
```

* Run Docker container with additional lvs statistics:

```ls
docker run -d -v /:/rootfs:ro --privileged=true \
    --pid=host --net=host \
    --name=collectd axibase/collectd \
    --atsd-url=tcp://atsd_host:tcp_port \
    --lvs
```

Details about collectd write_atsd plugin you can find at [write atsd page](https://github.com/axibase/atsd-collectd-plugin)

Credits to [Carles Amigó](https://github.com/fr3nd/docker-collectd) for the idea to re-mount rootfs.