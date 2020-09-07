#!/bin/bash

REF="$1"
REMOTE="$2"
# : ${SSH_PRIVKEY:=/run/secrets/id_rsa}

r10kconf="$(mktemp)"
cat << EOF > $r10kconf
# The location to use for storing cached Git repos
:cachedir: '/etc/puppetlabs/code/cache'

# A list of git repositories to create
:sources:
  :main:
    remote: '${REMOTE}'
    private_key: '${SSH_PRIVKEY}'
    basedir: '/etc/puppetlabs/code/environments'
EOF

export PATH=/opt/puppetlabs/bin:$PATH

if [[ $REF =~ 'refs/heads/' ]]; then
  branch=$(cut -d/ -f3 <<<"${REF}")
  #/nss_wrapper.sh g10k -config "$r10kconf" -branch "$branch" -verbose -debug
  g10k -config "$r10kconf" -branch "$branch" -verbose -debug
  rm -f "$r10kconf"
else
  echo "g10k skipping $REF"
fi
