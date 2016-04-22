## Collectd Docker Image

```
git clone https://github.com/axibase/dockers.git
git checkout collectd
cd docker-images
```

Copy content of conf/standard to collectd.conf to collect statistic about host except df and interface plugins (they will be collected for container). 	(1)
If you want to recieve all statistics from host machine copy conf/extened to collectd.conf.								(2)

```
docker build -t "axibase/collectd:5.5.0" .
docker run -d --pid=host --name=collectd axibase/collectd:5.5.0 --atsd-url=tcp://dockerhost:8081
# if you choose (2)
# docker run -d -v /:/`hostname`:ro --pid=host --net=host --name=collectd-test axibase/collectd:5.5.0 --atsd-url=tcp://dockerhost:8081
```

Details about collectd write_atsd plugin you can find at [write atsd page](https://github.com/axibase/atsd-collectd-plugin)
