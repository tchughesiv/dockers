FROM axibase/hadoop-hbase:2.6.4-1.2.2
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV version hbase_1.2.2
#metadata
LABEL com.axibase.vendor="Axibase Corporation" \
  com.axibase.product="Axibase Time Series Database" \
  com.axibase.code="ATSD" \
  com.axibase.revision="${version}"

#configure system
RUN locale-gen en_US.UTF-8 \
  && adduser --disabled-password --quiet --gecos "" axibase;

WORKDIR /opt

#download ATSD distrib
ADD https://axibase.com/public/atsd_ee_hbase_1.2.2.tar.gz ./

#required to extract before add entrypoint
RUN tar -xzf atsd_ee_hbase_1.2.2.tar.gz
ADD entrypoint.sh ./atsd/bin/

RUN mv atsd/hbase/lib/atsd.jar ${HBASE_NAME}/lib/ \
    && chown -R axibase:axibase .

USER axibase

#jmx, atsd(tcp), atsd(udp), pickle, http, https
EXPOSE 1099 8081 8082/udp 8084 8088 8443
VOLUME ["/opt"]

ENTRYPOINT ["/bin/bash","/opt/atsd/bin/entrypoint.sh"]

