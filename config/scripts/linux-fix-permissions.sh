#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
ROOT=${DIR}/../..;

sedi()
{
    sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@";
}

# permissions issues workaround for Linux
NEW_UID=$(id -u);
NEW_GID=$(id -g);
echo "Setting UID ($NEW_UID) and GID ($NEW_GID) to \"www-data\" user in $1 container ...";

if [ "$1" == "NGINX" ]; then
    sedi "s/\${UID}/$NEW_UID/g" ${ROOT}/modules/nginx/docker-compose.yml;
    sedi "s/\${GID}/$NEW_GID/g" ${ROOT}/modules/nginx/docker-compose.yml;
else
    sedi "s/\${UID}/$NEW_UID/g" ${ROOT}/modules/php-fpm/docker-compose.yml;
    sedi "s/\${GID}/$NEW_GID/g" ${ROOT}/modules/php-fpm/docker-compose.yml;
fi;

exit 0;