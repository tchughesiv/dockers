FROM registry.access.redhat.com/rhel7
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

COPY help.1 /
COPY licenses /licenses

#install atsd rpm with yum
RUN REPOLIST=rhel-7-server-rpms,axibase &&\
    printf "[axibase]\nname=Axibase Repository\nbaseurl=https://axibase.com/public/repository/rpm\nenabled=1\ngpgcheck=0\nprotect=1" >> /etc/yum.repos.d/axibase.repo &&\
    yum -y update-minimal --disablerepo "*" --enablerepo rhel-7-server-rpms --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs atsd && \
    yum clean all

#user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY uid_entrypoint.sh /opt/atsd/bin/
RUN usermod -d /opt/atsd -g 0 axibase &&\
    sed "s@axibase:x:`id axibase -u`:@axibase:x:\${USER_ID}:@g" /etc/passwd > /etc/passwd.template &&\
    STAT_VARS="DISTRHOME ATSD_START DFS_START ATSD_TSD HBASE_START" &&\
    for i in ${STAT_VARS}; do grep -ir "stat -c %U \"\$$i\"" /opt/atsd/ |\
      awk -F ':' '{print $1}' | uniq | xargs sed -i "s/stat -c %U \"\$$i\"/whoami/g"; done &&\
    grep -ir "stat -c %U /tmp/hsperfdata_$dfs_user" /opt/atsd/ |\
      awk -F ':' '{print $1}' | uniq | xargs sed -i "s@stat -c %U /tmp/hsperfdata_\$dfs_user@whoami@g" &&\
    chown -R axibase:0 /opt/atsd &&\
    chmod -R u+x /opt/atsd/bin &&\
    chmod -R g=u /opt/atsd /etc/passwd

USER axibase

#set hbase distributed mode false
RUN sed -i '/.*hbase.cluster.distributed.*/{n;s/.*/   <value>false<\/value>/}' /opt/atsd/hbase/conf/hbase-site.xml

#jmx, atsd(tcp), atsd(udp), pickle, http, https
EXPOSE 1099 8081 8082/udp 8084 8088 8443
VOLUME /opt/atsd/hdfs-cache /opt/atsd/hdfs-data /opt/atsd/hdfs-data-name

ENTRYPOINT ["/bin/bash","/opt/atsd/bin/uid_entrypoint.sh"]
CMD ["/opt/atsd/bin/entrypoint.sh"]
