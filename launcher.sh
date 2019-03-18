#!/bin/bash

echo "Checking certificates ( if /etc/letsencrypt/live/$(hostname)/privkey.pem exist )."
if [[ ! -e /etc/letsencrypt/live/$(hostname)/privkey.pem ]]
then
  if [[ ! "x$LETS_ENCRYPT_DOMAINS" == "x" ]]; then
    DOMAIN_CMD="-d $(echo $LETS_ENCRYPT_DOMAINS | sed 's/,/ -d /')"
  fi

  certbot-auto -n certonly --no-self-upgrade --agree-tos --standalone -t -m "$LETS_ENCRYPT_EMAIL" $DOMAIN_CMD
  ln -s /etc/letsencrypt/live/$(hostname) /etc/letsencrypt/certs
else
  certbot-auto renew --no-self-upgrade
fi

echo "Launcing apache2."
apache2 -DFOREGROUND
