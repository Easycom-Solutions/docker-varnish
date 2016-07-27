FROM alpine
MAINTAINER Frédéric TURPIN <frederic.turpin@easycom.digital>

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# RUN addgroup -S varnish --gid  && adduser -S -G varnish varnish

# Install varnish
RUN apk add --update --no-cache varnish && rm -rf /var/cache/apl/*

ENV VARNISH_LISTEN_ADDRESS 0.0.0.0
ENV VARNISH_LISTEN_PORT 80
ENV VARNISH_VCL_CONF ""
ENV VARNISH_BACKEND_ADDRESS backend
ENV VARNISH_BACKEND_PORT 80
ENV VARNISH_ADMIN_LISTEN_ADDRESS 127.0.0.1
ENV VARNISH_ADMIN_LISTEN_PORT 6082
ENV VARNISH_THREAD_POOLS thread_pools=2
ENV VARNISH_LISTEN_DEPTH listen_depth=1024

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["varnishd"]
