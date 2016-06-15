FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV ftpuser="ftp-user"

#ADD https://raw.githubusercontent.com/axibase/dockers/sftp/entrypoint.sh /opt/entrypoint.sh
#ADD https://raw.githubusercontent.com/axibase/dockers/sftp/sshd_config /etc/ssh/sshd_config
ADD entrypoint.sh /opt/entrypoint.sh
ADD sshd_config /etc/ssh/sshd_config

RUN apt-get update && apt-get upgrade && \
    apt-get install -y openssh-server && \
    groupadd ftpaccess && \
    mkdir -p /home/${ftpuser}/ftp && \
    mkdir -p /var/run/sshd && \
    useradd -m ${ftpuser} -g ftpaccess -s /usr/sbin/nologin && \
    chown ${ftpuser}:ftpaccess /home/${ftpuser}/ftp && \
    echo "/usr/sbin/nologin" >> /etc/shells && \
    chmod +x /opt/entrypoint.sh

    

WORKDIR /home/${ftpuser}

#sftp
EXPOSE 22
VOLUME ["/home/${ftpuser}"]
ENTRYPOINT ["/bin/sh", "/opt/entrypoint.sh"]
 
