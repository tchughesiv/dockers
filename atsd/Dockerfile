FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV version 10315

#configure system
RUN locale-gen en_US.UTF-8
#create directory for ssh daemon required by openssh-server
RUN mkdir -p /var/run/sshd

#configure users
RUN adduser --disabled-password --quiet --gecos "" axibase;

#add axibase repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 26AEE425A57967CFB323846008796A6514F3CB79
RUN echo "deb [arch=amd64] http://axibase.com/public/repository/deb/ ./" >> /etc/apt/sources.list
RUN apt-get update 

#install software including dependencies: openjdk-6-jdk, openssh-server, cron, telnet, sysstat, sed, debconf(>= 0.2.26), libc6, passwd, adduser, netcat-openbsd, iproute, net-tools
RUN apt-get install -y atsd=${version}; 

#set hbase distributed mode false
RUN sed -i '/.*hbase.cluster.distributed.*/{n;s/.*/   <value>false<\/value>/}' /opt/atsd/hbase/conf/hbase-site.xml

EXPOSE 22 1099 1883 8081 8084 8088 8883
VOLUME ["/opt/atsd"]

ENTRYPOINT ["/bin/bash","/opt/atsd/bin/start_container.sh"]

