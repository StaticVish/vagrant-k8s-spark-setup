#!/bin/bash
set -e
if [[ "$(hostname -d)" = 'localdomain' ]]; then
  #statements
  # remove ubuntu-bionic entry
  sed -e '/^.*ubuntu.*.localdomain.*/d' -i /etc/hosts

  _HOSTNAME="$(hostname -I | sed -E 's/\./\-/gm;t;d')"
  hostnamectl set-hostname ip-"$_HOSTNAME".sslip.io
  echo -e "$(hostname -I) \t $(hostname --fqdn) \t $(hostname --short)" >> /etc/hosts
fi
