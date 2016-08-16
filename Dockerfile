FROM axibase/hbase:1.2.2
MAINTAINER ATSD Developers <dev-atsd@axibase.com>

#metadata
LABEL com.axibase.vendor="Axibase Corporation" \
  com.axibase.product="Axibase Time Series Database" \
  com.axibase.code="ATSD"

WORKDIR /home/axibase/
ADD  entrypoint-atsd.sh /
ADD  rules.xml /home/axibase/

USER root
RUN apt-get update \
    && apt-get install -y curl \
    && chown -R axibase:axibase /home/axibase /entrypoint-atsd.sh

USER axibase

ENTRYPOINT ["/bin/bash","/entrypoint-atsd.sh"]

