FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV fptuser="axibase-ftp"

RUN apt-get update && apt-get upgrade \
    apt-get install vsftpd openssh-server curl && \
    useradd -m ${fptuser} -s /usr/sbin/nologin && \
    echo "/usr/sbin/nologin" >> /etc/shells

WORKDIR /opt
RUN curl -L -o entrypoint.sh https://raw.githubusercontent.com/axibase/dockers/sftp/entrypoint.sh

#ssh, ftp
EXPOSE 21,22
ENTRYPOINT ["/opt/entrypoint.sh"]
 
