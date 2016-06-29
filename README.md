## Collectd Docker Image


To collect all statistics from docker host and send them to ATSD run

```
docker run -d -v /:/rootfs:ro --pid=host --net=host \
    --name=collectd axibase/collectd \
    --atsd-url=tcp://atsd_host:tcp_port
```

Details about collectd write_atsd plugin you can find at [write atsd page](https://github.com/axibase/atsd-collectd-plugin)

To collect all statistics from docker host and send them to Graphite run

```
docker run -d -v /:/rootfs:ro --pid=host --net=host \
    --name=collectd axibase/collectd \
    --protocol=tcp --host=graphite_host --port=tcp_port
```

Credits to Carles Amigó for https://github.com/fr3nd/docker-collectd
