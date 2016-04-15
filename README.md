## Dockerfile to build the image with Hadoop2.5.2 and Hbase1.1.4

### To start:

#### Be sure the docker host contains the following row in `/etc/hosts`:
```
<docker.machine.ip.addr> <hostname>
```
#### Pull image:

```
docker pull axibase/hadoop-hbase:2.5.2-1.1.4
```

#### Start container:
```
docker run -d --net=host --name=hadoop-hbase-new axibase/hadoop-hbase
```
