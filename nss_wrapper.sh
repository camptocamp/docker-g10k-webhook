#!/bin/bash

if ! getent passwd "$(id -u)" &> /dev/null && [ -e /usr/lib/libnss_wrapper.so ]; then
	export LD_PRELOAD='/usr/lib/libnss_wrapper.so'
	export NSS_WRAPPER_PASSWD="$(mktemp)"
	export NSS_WRAPPER_GROUP="$(mktemp)"
	echo "webhook:x:$(id -u):$(id -g):webhook:/:/bin/false" > "$nss_wrapper_passwd"
	echo "webhook:x:$(id -g):" > "$nss_wrapper_group"
fi

exec "$@"
