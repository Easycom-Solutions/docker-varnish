#!/bin/sh
set -e

VARNISH_BACKEND="-b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}"

if [ ! -z $VARNISH_VCL_CONF ]; then
	VARNISH_BACKEND="-f ${VARNISH_VCL_CONF}"
fi

VARNISH_OPTS="-a ${VARNISH_LISTEN_ADDRESS}:${VARNISH_LISTEN_PORT} \
              ${VARNISH_BACKEND} \
              -T ${VARNISH_ADMIN_LISTEN_ADDRESS}:${VARNISH_ADMIN_LISTEN_PORT} \
              -p ${VARNISH_THREAD_POOLS} \
              -p ${VARNISH_LISTEN_DEPTH} -F"

if [ ! -z $VARNISH_ALLOW_INLINE_C ]; then
	VARNISH_OPTS="$VARNISH_OPTS -p vcc_allow_inline_c=on"
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- varnishd "$@"
# if no args, use env variables
elif [ "varnishd" = "$1" ] && [ -z "$2" ]; then
	set -- varnishd $VARNISH_OPTS
# if "options", write env variables (test)
elif [ "options" = "$1" ]; then
	set -- echo $VARNISH_OPTS
fi

exec "$@"
