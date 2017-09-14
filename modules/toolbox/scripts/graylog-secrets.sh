#!/bin/sh

if [ "$GRAYLOG_ENABLED" == "false" ]; then
    echo Skipping Graylog secrets generation ...;
    exit 0;
fi;

sedi()
{
    sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@";
}

echo Generating Graylog secrets ...;

password_secret=$(openssl rand -hex 64);
root_password_sha2=$(echo -n $GRAYLOG_ROOT_PASSWORD_SHA2 | openssl dgst -sha256 | sed 's/^.* //');

/bin/cp /generated/graylog/.env.blueprint /generated/graylog/.env;
sedi "s/\${GRAYLOG_PASSWORD_SECRET}/$password_secret/g" /generated/graylog/.env;
sedi "s/\${GRAYLOG_ROOT_PASSWORD_SHA2}/$root_password_sha2/g" /generated/graylog/.env;

echo Graylog secrets generated!;
exit 0;