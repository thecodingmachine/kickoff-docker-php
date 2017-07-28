#!/bin/sh

if [ ! -f "/generated/traefik/certs/$VIRTUAL_HOST.key" ]; then
    rm -rf /certs/*;
    openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout /generated/traefik/certs/$VIRTUAL_HOST.key -out /generated/traefik/certs/$VIRTUAL_HOST.crt -days 365 -subj "/C=FR/ST=PARIS/L=PARIS/O=Kickoff/OU=Kickoff/CN=*.$VIRTUAL_HOST";
else
    echo Self-signed certificate already generated, skipping ...;
fi;

exit 0;