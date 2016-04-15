FROM java:openjdk-7-jdk
MAINTAINER ATSD Developers <dev-atsd@axibase.com>

RUN apt-get update && apt-get install -y vim 

ADD hadoop /opt/hadoop
ADD hbase /opt/hbase
ADD entrypoint.sh /opt/
RUN chown -R root:root /opt
RUN /opt/hadoop/bin/hdfs namenode -format

ENTRYPOINT ["/bin/bash", "/opt/entrypoint.sh"]

