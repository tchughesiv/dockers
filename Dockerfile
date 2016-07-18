FROM axibase/hadoop-hbase:2.6.4-1.2.2
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV version 13697
#metadata
LABEL com.axibase.vendor="Axibase Corporation" \
  com.axibase.product="Axibase Time Series Database" \
  com.axibase.code="ATSD" \
  com.axibase.revision="${version}"

#configure system
RUN locale-gen en_US.UTF-8 \
  && adduser --disabled-password --quiet --gecos "" axibase;

WORKDIR /opt


#download distrib
ADD https://axibase.com/public/atsd_ce.tar.gz ./
#required to extract before add entrypoint
RUN tar -xzvf atsd_ce.tar.gz
ADD entrypoint.sh ./atsd/bin/
ADD https://axibase.com/public/atsd_hbase-1.2.2.tar.gz ./

RUN chmod +x ./atsd/bin/* \
    && tar -xzf atsd_hbase-1.2.2.tar.gz \
    && mv target/atsd-executable.jar ./atsd/atsd/bin/ \
    && mv target/atsd.jar ${HBASE_NAME}/lib/ \
    && chown -R axibase:axibase .

USER axibase

#kepp distributed for testing puprope
#RUN sed -i '/.*hbase.cluster.distributed.*/{n;s/.*/   <value>false<\/value>/}' /opt/atsd/hbase/conf/hbase-site.xml


#jmx, atsd(tcp), atsd(udp), pickle, http, https
EXPOSE 1099 8081 8082/udp 8084 8088 8443
VOLUME ["/opt"]

ENTRYPOINT ["/bin/bash","/opt/atsd/bin/entrypoint.sh"]

