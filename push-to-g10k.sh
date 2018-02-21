#!/bin/bash

REF="$1"

export PATH=/opt/puppetlabs/bin:$PATH

if [[ $REF =~ 'refs/heads/' ]]; then
  branch=$(cut -d/ -f3 <<<"${REF}")
  g10k -config /etc/puppetlabs/r10k/r10k.yaml -branch "$branch"
else
  echo "g10k skipping $REF"
fi
