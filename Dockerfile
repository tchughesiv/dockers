FROM ubuntu:16.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV version 1.0.3
env JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
#metadata
LABEL com.axibase.vendor="Axibase Corporation" \
  com.axibase.product="Axibase Time Series Database" 

RUN apt-get update && apt-get install -y locales

RUN locale-gen en_US.UTF-8 \
  && adduser --disabled-password --quiet --gecos "" axibase

WORKDIR /home/axibase/
ADD https://archive.apache.org/dist/hbase/hbase-${version}/hbase-${version}-bin.tar.gz .

RUN tar -xzf ./hbase-${version}-bin.tar.gz \
    && rm -f ./hbase-${version}-bin.tar.gz \
    && apt-get update \
    && apt-get install -y openjdk-8-jdk

ADD hbase-site.xml ./hbase-${version}/conf/
ADD hbase-env.sh ./hbase-${version}/conf/
ADD entrypoint-hbase.sh /

RUN chown -R axibase:axibase /home/axibase /entrypoint-hbase.sh
USER axibase

ENTRYPOINT ["/bin/bash","/entrypoint-hbase.sh"]

