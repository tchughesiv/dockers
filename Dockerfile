FROM axibase/atsd:1.0.3_dev
MAINTAINER ATSD Developers <dev-atsd@axibase.com>

ADD entrypoint-api-test.sh /

USER root
RUN apt-get update \
    && apt-get install -y git maven \
    && chown axibase:axibase /entrypoint-api-test.sh

USER axibase


ENTRYPOINT ["/bin/bash","/entrypoint-api-test.sh"]

