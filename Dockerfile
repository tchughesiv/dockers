FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV ftpuser="axibase-ftp"

RUN apt-get update && apt-get upgrade && \
    apt-get install -y vsftpd openssh-server curl && \
    groupadd ftpaccess && \
    mkdir -p /home/${ftpuser}/ftp && \
    useradd -m ${ftpuser} -g ftpaccess -s /usr/sbin/nologin && \
    chown ${ftpuser}:ftpaccess /home/${ftpuser}/ftp && \
    echo "/usr/sbin/nologin" >> /etc/shells

RUN curl -L -o /opt/entrypoint.sh https://raw.githubusercontent.com/axibase/dockers/sftp/entrypoint.sh && \
    chmod +x /opt/entrypoint.sh && \
    curl -L -o /etc/ssh/sshd_config https://raw.githubusercontent.com/axibase/dockers/sftp/sshd_config && \
    curl -L -o /etc/vsftpd.conf https://raw.githubusercontent.com/axibase/dockers/sftp/vsftpd.conf
    

WORKDIR /home/${ftpuser}

#ftp ssh
EXPOSE 21 22
VOLUME ["/home/${ftpuser}"]
ENTRYPOINT ["/opt/entrypoint.sh"]
 
