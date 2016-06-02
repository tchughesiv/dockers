FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV ftpuser="axibase-ftp"

RUN apt-get update && apt-get upgrade && \
    apt-get install -y vsftpd openssh-server curl && \
    useradd -m ${ftpuser} -s /usr/sbin/nologin && \
    echo "/usr/sbin/nologin" >> /etc/shells

RUN curl -L -o /opt/entrypoint.sh https://raw.githubusercontent.com/axibase/dockers/sftp/entrypoint.sh && \
    chmod +x /opt/entrypoint.sh && \
    curl -L -o /etc/vsftpd.conf https://raw.githubusercontent.com/axibase/dockers/sftp/vsftpd.conf

WORKDIR /home/${ftpuser}

#ssh, ftp
EXPOSE 21 22
ENTRYPOINT ["/opt/entrypoint.sh"]
 
