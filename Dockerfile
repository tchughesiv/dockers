FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV ftpuser="axibase-ftp"

RUN apt-get update && apt-get upgrade && \
    apt-get install -y vsftpd openssh-server curl && \
    groupadd ftpaccess && \
    useradd -m ${ftpuser} -g ftpaccess -s /usr/sbin/nologin && \
    echo "/usr/sbin/nologin" >> /etc/shells

RUN curl -L -o /opt/entrypoint.sh https://raw.githubusercontent.com/axibase/dockers/sftp/entrypoint.sh && \
    chmod +x /opt/entrypoint.sh && \
    curl -L -o /etc/ssh/sshd_config https://raw.githubusercontent.com/axibase/dockers/sftp/sshd_config && \
    curl -L -o /etc/vsftpd.conf https://raw.githubusercontent.com/axibase/dockers/sftp/vsftpd.conf && \
    chown root /home/${ftpuser} && \
    mkdir -p /home/${ftpuser}/ftpdata && \
    chown ${ftpuser}:ftpaccess /home/${ftpuser}/ftpdata

WORKDIR /home/${ftpuser}/ftpdata

#ftp ssh
EXPOSE 21 22
VOLUME ["/home/${ftpuser}/ftpdata"]
ENTRYPOINT ["/opt/entrypoint.sh"]
 
