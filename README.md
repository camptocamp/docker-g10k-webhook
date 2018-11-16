G10k webhook
============

This container provides a webhook service for [g10k](https://github.com/xorpaul/g10k).


## Environment

The following environment variables are supported:

 - `HOOK_SECRET`: the webhook PSK


## Secrets

You should set the following secrets:

  - `id_rsa`: the SSH private key for git checkouts


## Volumes

You should mount the following volumes:

  - `/etc/puppetlabs/code`: recipient destination of checked out code
  - `/etc/puppetlabs/r10k/r10k.yaml` (optional): if present, used to initialize
