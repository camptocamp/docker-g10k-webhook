#!/bin/bash

if ! getent passwd "$(id -u)" &> /dev/null && [ -e /usr/lib/libnss_wrapper.so ]; then
	export ld_preload='/usr/lib/libnss_wrapper.so'
	export nss_wrapper_passwd="$(mktemp)"
	export nss_wrapper_group="$(mktemp)"
	echo "webhook:x:$(id -u):$(id -g):webhook:/:/bin/false" > "$nss_wrapper_passwd"
	echo "webhook:x:$(id -g):" > "$nss_wrapper_group"
fi

exec "$@"
