#!/bin/sh

if [ "$ENV" == "local" ]; then
    echo Skipping .htdigest file generation ...;
    exit 0;
fi;

echo Generating .htdigest file ...;

rm -f /generated/traefik/auth/.htdigest;
printf "%s:%s:%s" "$TRAEFIK_USER" "traefik" $(printf "$TRAEFIK_USER:traefik:$TRAEFIK_PASSWORD" | openssl dgst -md5 | sed 's/^.* //') > /generated/traefik/auth/.htdigest;

if [ ! -f "/generated/traefik/auth/.htdigest" ]; then
    echo Failed to generate the .htdigest file;
    exit 1;
fi;

echo .htdigest file generated!;
exit 0;