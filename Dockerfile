FROM easycom/base:stretch
MAINTAINER Frédéric TURPIN <frederic.turpin@easycom.digital>

ENV VARNISH_VERSION=4.0.4
COPY varnish-${VARNISH_VERSION}.tar.gz /tmp/varnish.tar.gz

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get install -y autotools-dev automake make libreadline-dev libtool autoconf libncurses-dev xsltproc groff-base libpcre3-dev pkg-config python-all python-docutils

RUN cd /tmp/ \
  && tar xfvz varnish.tar.gz \ 
  && mv varnish-* varnish \
  && cd varnish/ \
  && ./autogen.sh \
  && ./configure --prefix=/usr \
  && make \
  && make install

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
ENV VARNISH_ALLOW_INLINE_C ""

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["varnishd"]

