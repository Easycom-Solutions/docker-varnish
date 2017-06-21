#!/bin/sh
set -e

# Open files (usually 1024, which is way too small for varnish)
ulimit -n ${NFILES:-131072}

# Maxiumum locked memory size for shared memory log
ulimit -l ${MEMLOCK:-82000}

VARNISH_BACKEND="-b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}"

if [ ! -z $VARNISH_VCL_CONF ]; then
	VARNISH_BACKEND="-f ${VARNISH_VCL_CONF}"
fi

VARNISH_OPTIONS="-p ${VARNISH_THREAD_POOLS} -p ${VARNISH_LISTEN_DEPTH}"

if [ ! -z $VARNISH_CUSTOM_OPTIONS ]; then
	VARNISH_OPTIONS="${VARNISH_OPTIONS} ${VARNISH_CUSTOM_OPTIONS}"
fi

if [ ! -z $VARNISH_SECRET_FILE ]; then
	VARNISH_OPTIONS="${VARNISH_OPTIONS} -S ${VARNISH_SECRET_FILE}"
fi

if [ ! -z $VARNISH_STORAGE ]; then
	VARNISH_OPTIONS="${VARNISH_OPTIONS} -s ${VARNISH_STORAGE}"
fi

VARNISH_OPTS="-a ${VARNISH_LISTEN_ADDRESS}:${VARNISH_LISTEN_PORT} \
              ${VARNISH_BACKEND} \
              -T ${VARNISH_ADMIN_LISTEN_ADDRESS}:${VARNISH_ADMIN_LISTEN_PORT} \
              ${VARNISH_OPTIONS} -F"

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
