FROM easycom/base:stretch
MAINTAINER Frédéric TURPIN <frederic.turpin@easycom.digital>

ENV VARNISH_VERSION=3.0.7

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get install -y autotools-dev automake make libreadline-dev libtool autoconf libncurses-dev xsltproc groff-base libpcre3-dev pkg-config python-all python-docutils curl git

RUN cd /tmp/ \
  && curl -o varnish.tgz https://repo.varnish-cache.org/source/varnish-${VARNISH_VERSION}.tar.gz \
  && git clone https://github.com/lkarsten/libvmod-ipcast ipcast \
  && tar xfvz varnish.tgz \ 
  && mv varnish-* varnish \
  && cd varnish/ \
  && ./autogen.sh \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && cd ../ipcast/ \
  && ./autogen.sh \
  && ./configure VARNISHSRC=/tmp/varnish \
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

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["varnishd"]

