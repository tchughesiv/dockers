FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>
ENV s=60
ENV c=60

RUN apt-get update 
RUN apt-get install -y gcc ncurses-dev
WORKDIR /opt/nmon


RUN wget -O nmon.c https://raw.githubusercontent.com/axibase/nmon/master/lmon16d.c
RUN wget -O entrypoint.sh https://raw.githubusercontent.com/axibase/dockers/nmon/entrypoint.sh

RUN cc -o nmon lmon16d.c -g -O3 -Wall -D JFS -D GETUSER -D LARGEMEM -lncurses -lm -g -D KERNEL_2_6_18 -D X86

ENTRYPOINT ["/opt/nmon/entrypoint.sh"]




