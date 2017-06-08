FROM ubuntu:16.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV version 1.2.0-cdh5.10.1
env JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
#metadata
LABEL com.axibase.vendor="Axibase Corporation" \
  com.axibase.product="Axibase Time Series Database" 

RUN apt-get update && apt-get install -y locales

RUN locale-gen en_US.UTF-8 \
  && adduser --disabled-password --quiet --gecos "" axibase

WORKDIR /home/axibase/
ADD https://archive.cloudera.com/cdh5/cdh/5/hbase-${version}.tar.gz .

RUN tar -xzf ./hbase-${version}.tar.gz \
    && rm -f ./hbase-${version}.tar.gz \
    && apt-get update \
    && apt-get install -y openjdk-8-jdk

ADD hbase-site.xml ./hbase-${version}/conf/
ADD hbase-env.sh ./hbase-${version}/conf/
ADD entrypoint-hbase.sh /

RUN chown -R axibase:axibase /home/axibase /entrypoint-hbase.sh
USER axibase

ENTRYPOINT ["/bin/bash","/entrypoint-hbase.sh"]

