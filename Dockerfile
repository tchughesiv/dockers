FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV version 1.2.2
env JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64
#metadata
LABEL com.axibase.vendor="Axibase Corporation" \
  com.axibase.product="Axibase Time Series Database" 

RUN locale-gen en_US.UTF-8 \
  && adduser --disabled-password --quiet --gecos "" axibase

WORKDIR /home/axibase/
ADD https://www.apache.org/dist/hbase/${version}/hbase-${version}-bin.tar.gz .

RUN tar -xzf ./hbase-${version}-bin.tar.gz \
    && rm -f ./hbase-${version}-bin.tar.gz \
    && apt-get update \
    && apt-get install -y openjdk-7-jdk

ADD hbase-site.xml ./hbase-${version}/conf/
ADD hbase-env.sh ./hbase-${version}/conf/
ADD entrypoint-hbase.sh /

RUN chown -R axibase:axibase /home/axibase /entrypoint-hbase.sh
USER axibase

ENTRYPOINT ["/bin/bash","/entrypoint-hbase.sh"]

