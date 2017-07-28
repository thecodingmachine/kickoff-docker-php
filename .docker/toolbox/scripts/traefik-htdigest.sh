#!/bin/sh

rm -f /generated/traefik/auth/.htdigest;
printf "%s:%s:%s" "$TRAEFIK_USER" "traefik" $(printf "$TRAEFIK_USER:traefik:$TRAEFIK_PASSWORD" | openssl dgst -md5 | sed 's/^.* //') > /generated/traefik/auth/.htdigest;

exit 0;