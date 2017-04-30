FROM ubuntu:14.04
MAINTAINER Lucy Davies <lucy@lucymhdavies.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV MAPCRAFTER_VERSION=2.3-1 MAPCRAFTER_ARCH=amd64
ENV MAPCRAFTER_PACKAGE=mapcrafter_${MAPCRAFTER_VERSION}_${MAPCRAFTER_ARCH}.deb

RUN apt-get update
RUN apt-get install -y -q wget python \
  libboost-iostreams1.55.0 libboost-system1.55.0 libboost-filesystem1.55.0 \
  libboost-program-options1.55.0 libjpeg-turbo8
RUN apt-get clean

RUN wget http://mapcrafter.org/packages/ubuntu/trusty/main/$MAPCRAFTER_PACKAGE
RUN dpkg --install $MAPCRAFTER_PACKAGE
RUN rm $MAPCRAFTER_PACKAGE

WORKDIR ["/data"]
VOLUME ["/data"]
