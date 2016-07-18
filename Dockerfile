FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>

ENV HADOOP_NAME=hadoop-2.6.4
ENV HBASE_VERSION=1.2.2
ENV HBASE_NAME=hbase-${HBASE_VERSION}

WORKDIR /opt
RUN apt-get update && \
    apt-get install -y openjdk-7-jdk wget && \
    wget https://archive.apache.org/dist/hadoop/core/${HADOOP_NAME}/${HADOOP_NAME}.tar.gz && \
    tar -xzf ${HADOOP_NAME}.tar.gz

RUN wget https://www.apache.org/dist/hbase/${HBASE_VERSION}/${HBASE_NAME}-bin.tar.gz && \
    tar -xzf ${HBASE_NAME}-bin.tar.gz

ADD entrypoint.sh ./
ADD ./hadoop/etc/hadoop/core-site.xml ${HADOOP_NAME}/etc/hadoop/ 
ADD ./hadoop/etc/hadoop/hdfs-site.xml ${HADOOP_NAME}/etc/hadoop/ 
ADD ./hadoop/sbin/slaves.sh ${HADOOP_NAME}/sbin/
ADD ./hbase/conf/hbase-site.xml ${HBASE_NAME}/conf/ 
ADD ./hbase/bin/regionservers.sh ${HBASE_NAME}/bin/
ADD ./hbase/bin/zookeepers.sh ${HBASE_NAME}/bin/

RUN chmod +x entrypoint.sh ${HADOOP_NAME}/sbin/* ${HBASE_NAME}/bin


ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
RUN /opt/${HADOOP_NAME}/bin/hdfs namenode -format

ENTRYPOINT ["/bin/bash", "/opt/entrypoint.sh"]

