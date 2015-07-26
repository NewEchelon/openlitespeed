FROM debian:jessie
MAINTAINER Yann Verry <docker@verry.org>

# update apt repo
RUN apt-get update

# install dev env
RUN apt-get -y install wget build-essential libssl-dev libpcre3-dev libgeoip-dev libexpat1-dev

# Fetch Openlistespeed
RUN cd /usr/src && \
	wget http://open.litespeedtech.com/packages/openlitespeed-1.4.11.tgz && \
	tar xf openlitespeed-1.4.11.tgz && \
	cd openlitespeed-1.4.11


# Build
RUN cd /usr/src/openlitespeed-1.4.11 && ./configure && \
	make && \
	make install && \
	chown nobody -R /usr/local/lsws

# cleanup
RUN apt-get -y purge wget build-essential libssl-dev libpcre3-dev libgeoip-dev && \
	rm -rf /usr/src/*

# openlite config
VOLUME /usr/local/lsws

# expose admin
EXPOSE 7080 8088

#ENTRYPOINT ["/usr/bin/lswsctrl"]
CMD ["/usr/local/lsws/bin/openlitespeed","-d"]
