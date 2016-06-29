## Collectd Docker Image

This image collects statistics from Docker host (engine) and not from a container where it's launched.

### Send Statistics to Axibase Time Series Database

```ls
docker run -d -v /:/rootfs:ro --pid=host --net=host \
    --name=collectd axibase/collectd \
    --atsd-url=tcp://atsd_host:tcp_port
```

Details about collectd write_atsd plugin you can find at [write atsd page](https://github.com/axibase/atsd-collectd-plugin)

### Send Statistics to Graphite

```ls
docker run -d -v /:/rootfs:ro --pid=host --net=host \
    --name=collectd axibase/collectd \
    --protocol=tcp --host=graphite_host --port=tcp_port
```

Credits to [Carles Amigó](https://github.com/fr3nd/docker-collectd) for the idea to re-mount rootfs.
