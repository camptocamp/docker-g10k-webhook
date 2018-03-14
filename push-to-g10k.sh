#!/bin/bash

REF="$1"
REMOTE="$2"

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

export PATH=/opt/puppetlabs/bin:$PATH

if [[ $REF =~ 'refs/heads/' ]]; then
  branch=$(cut -d/ -f3 <<<"${REF}")
  g10k -config /etc/puppetlabs/r10k/r10k.yaml -branch "$branch"
else
  echo "g10k skipping $REF"
fi
