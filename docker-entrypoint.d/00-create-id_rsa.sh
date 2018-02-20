#!/bin/bash

if test -n "${RSA_PRIVATE_KEY}"; then
  echo -e "${RSA_PRIVATE_KEY}" > ~/.ssh/id_rsa
  chmod 0600 ~/.ssh/id_rsa
fi
