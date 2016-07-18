## Dockerfile to build the image with Hadoop2.6.4 and Hbase1.2.2

### To start:

#### Be sure the docker host contains the following row in `/etc/hosts`:
```
<docker.machine.ip.addr> <hostname>
```
#### Pull image:
```
docker pull axibase/hadoop-hbase:2.6.4-1.2.2
```
#### Start container:
```
docker run -d --net=host --name="hadoop2.6.4-hbase1.2.2" axibase/hadoop-hbase:2.6.4-1.2.2
```
