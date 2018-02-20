#!/bin/bash

touch /etc/puppetlabs/code/environments/r10k-initializing.lock

g10k -config /etc/puppetlabs/r10k/r10k.yaml -info

rm /etc/puppetlabs/code/environments/r10k-initializing.lock
