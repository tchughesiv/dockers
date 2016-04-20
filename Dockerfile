FROM ubuntu:14.04
MAINTAINER ATSD Developers <dev-atsd@axibase.com>

RUN apt-get update 
RUN apt-get install -y gcc ncurses-dev

WORKDIR /opt/nmon


