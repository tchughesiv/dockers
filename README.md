## Collectd Docker Image


If you want to collect statistic about docker host except df and interface plugins (they will be collected for container)
```
docker run -d --pid=host --name=collectd-container axibase/collectd --atsd-url=tcp://atsd_host:tcp_port --conf=container
```

If you want to collect all statistics from docker host

```
docker run -d -v /:/`hostname`:ro --pid=host --net=host --name=collectd-host axibase/collectd --atsd-url=tcp://atsd_host:tcp_port --conf=host
```

Details about collectd write_atsd plugin you can find at [write atsd page](https://github.com/axibase/atsd-collectd-plugin)
