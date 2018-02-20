#!/bin/bash

DIR=/docker-entrypoint.d

if [[ -d "$DIR" ]]
then
  /bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
fi

exec /usr/local/bin/webhook -hooks /etc/webhook/*.json -verbose "$@"
