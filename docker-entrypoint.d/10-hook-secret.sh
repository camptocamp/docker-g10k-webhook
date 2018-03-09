#!/bin/sh

sed -i "s/%{HOOK_SECRET}/${HOOK_SECRET}/g" /etc/webhook/*.json
