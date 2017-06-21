FROM debian:wheezy
MAINTAINER Frédéric TURPIN <frederic.turpin@easycom.digital>

ADD ./bashrc.root /root/.bashrc

# Install basics
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& apt-get -y --no-install-recommends install nano \ 
												  htop \
	   											  iptraf

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https curl \
  && curl https://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add - \
  && echo "deb https://repo.varnish-cache.org/debian/ wheezy varnish-3.0" > /etc/apt/sources.list.d/varnish-cache.list \
  && apt-get update \
  && apt-get install -y varnish \
  && service varnish stop \
  
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV NFILES 131072
ENV MEMLOCK 82000
ENV VARNISH_LISTEN_ADDRESS 0.0.0.0
ENV VARNISH_LISTEN_PORT 80
ENV VARNISH_VCL_CONF ""
ENV VARNISH_BACKEND_ADDRESS backend
ENV VARNISH_BACKEND_PORT 80
ENV VARNISH_ADMIN_LISTEN_ADDRESS 127.0.0.1
ENV VARNISH_ADMIN_LISTEN_PORT 6082
ENV VARNISH_THREAD_POOLS thread_pools=2
ENV VARNISH_LISTEN_DEPTH listen_depth=1024
ENV VARNISH_SECRET_FILE ""
ENV VARNISH_CUSTOM_OPTIONS ""

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["varnishd"]

