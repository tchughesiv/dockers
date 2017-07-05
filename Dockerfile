FROM docker.io/centos:7
MAINTAINER ATSD Developers <dev-atsd@axibase.com>

#default to UTF-8 file.encoding
ENV LANG en_US.utf8

#metadata
LABEL com.axibase.vendor="Axibase Corporation" \
      com.axibase.product="Axibase Time Series Database" \
      com.axibase.code="ATSD" \
      com.axibase.function="database" \
      com.axibase.platform="linux" \
      name="axibase/atsd" \
      vendor="Axibase Corporation" \
      version="3.2" \
      release="1" \
      summary="Axibase Time Series Database" \
      description="Axibase will ....."

#install atsd rpm with yum
RUN printf "[axibase]\nname=Axibase Repository\nbaseurl=https://axibase.com/public/repository/rpm\nenabled=1\ngpgcheck=0\nprotect=1" >> /etc/yum.repos.d/axibase.repo &&\
    yum install -y atsd &&\
    yum clean all

USER axibase

#set hbase distributed mode false
RUN sed -i '/.*hbase.cluster.distributed.*/{n;s/.*/   <value>false<\/value>/}' /opt/atsd/hbase/conf/hbase-site.xml

#jmx, atsd(tcp), atsd(udp), pickle, http, https
EXPOSE 1099 8081 8082/udp 8084 8088 8443

ENTRYPOINT ["/bin/bash","/opt/atsd/bin/entrypoint.sh"]
