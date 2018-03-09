#!/bin/bash

mkdir -p /etc/puppetlabs/r10k
cat << EOF > /etc/puppetlabs/r10k/r10k.yaml
# The location to use for storing cached Git repos
:cachedir: '/etc/puppetlabs/code/cache'

# A list of git repositories to create
:sources:
  :main:
    remote: '${REMOTE}'
    basedir: '/etc/puppetlabs/code/environments'
EOF
