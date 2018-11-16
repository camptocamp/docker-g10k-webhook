#!/bin/bash


if test -f /etc/puppetlabs/r10k/r10k.yaml; then
  touch /etc/puppetlabs/code/environments/r10k-initializing.lock
  /nss_wrapper.sh g10k -config /etc/puppetlabs/r10k/r10k.yaml -info
  rm /etc/puppetlabs/code/environments/r10k-initializing.lock
fi
