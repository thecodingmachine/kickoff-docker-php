#!/bin/sh

if [ "$ENV" != "local" ]; then
    echo Skipping self-signed certificate generation ...;
    exit 0;
fi;

if [ ! -f "/generated/traefik/certs/$VIRTUAL_HOST.key" ]; then
    echo Generating the self-signed certificate ...

    rm -rf /generated/traefik/certs/*.crt;
    rm -rf /generated/traefik/certs/*.key;
    openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout /generated/traefik/certs/$VIRTUAL_HOST.key -out /generated/traefik/certs/$VIRTUAL_HOST.crt -days 365 -subj "/C=FR/ST=PARIS/L=PARIS/O=Kickoff/OU=Kickoff/CN=*.$VIRTUAL_HOST";

    if [ ! -f "/generated/traefik/certs/$VIRTUAL_HOST.key" ]; then
        echo Failed to generate the self-signed certificate;
        exit 1;
    fi;

    echo Self-signed certificate generated!;
    exit 0;
fi;

echo Self-signed certificate already generated, skipping ...;
exit 0;