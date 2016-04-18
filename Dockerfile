FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>

ENV HADOOP_NAME=hadoop-2.5.2
ENV HBASE_NAME=hbase-1.1.4

WORKDIR /opt
RUN apt-get update && \
    apt-get install -y openjdk-7-jdk wget && \
    wget https://archive.apache.org/dist/hadoop/core/${HADOOP_NAME}/${HADOOP_NAME}.tar.gz && \
    tar -xzf ${HADOOP_NAME}.tar.gz

RUN wget https://www.apache.org/dist/hbase/1.1.4/${HBASE_NAME}-bin.tar.gz && \
    tar -xzf ${HBASE_NAME}-bin.tar.gz && \
    wget https://raw.githubusercontent.com/axibase/dockers/hadoop-2.5.2%2Bhbase-1.1.4/entrypoint.sh && \
    chmod +x entrypoint.sh && \
    wget -O ${HADOOP_NAME}/etc/hadoop/core-site.xml https://raw.githubusercontent.com/axibase/dockers/hadoop-2.5.2%2Bhbase-1.1.4/hadoop/etc/hadoop/core-site.xml && \
    wget -O ${HADOOP_NAME}/etc/hadoop/hdfs-site.xml https://raw.githubusercontent.com/axibase/dockers/hadoop-2.5.2%2Bhbase-1.1.4/hadoop/etc/hadoop/hdfs-site.xml && \
    wget -O ${HADOOP_NAME}/sbin/slaves.sh https://raw.githubusercontent.com/axibase/dockers/hadoop-2.5.2%2Bhbase-1.1.4/hadoop/sbin/slaves.sh && \
    chmod +x ${HADOOP_NAME}/sbin/slaves.sh && \
    wget -O ${HBASE_NAME}/conf/hbase-site.xml https://raw.githubusercontent.com/axibase/dockers/hadoop-2.5.2%2Bhbase-1.1.4/hbase/conf/hbase-site.xml && \
    wget -O ${HBASE_NAME}/bin/regionservers.sh https://raw.githubusercontent.com/axibase/dockers/hadoop-2.5.2%2Bhbase-1.1.4/hbase/bin/regionservers.sh && \
    chmod +x ${HBASE_NAME}/bin/regionservers.sh && \
    wget -O ${HBASE_NAME}/bin/zookeepers.sh https://raw.githubusercontent.com/axibase/dockers/hadoop-2.5.2%2Bhbase-1.1.4/hbase/bin/zookeepers.sh && \
    chmod +x ${HBASE_NAME}/bin/zookeepers.sh

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
RUN /opt/${HADOOP_NAME}/bin/hdfs namenode -format

ENTRYPOINT ["/bin/bash", "/opt/entrypoint.sh"]

