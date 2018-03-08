#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
ROOT=${DIR}/../..;

sedi()
{
    sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@";
}

# permissions issues workaround
NEW_UID=$(id -u);

if [ "$1" == "NGINX" ]; then
    echo "Setting UID ($NEW_UID) to \"www-data\" user in $1 container ...";
    sedi "s/\${UID}/$NEW_UID/g" "${ROOT}/modules/nginx/docker-compose.yml";
elif [ "$1" == "PHP-FPM" ]; then
    echo "Setting UID ($NEW_UID) to \"www-data\" user in $1 container ...";
    sedi "s/\${UID}/$NEW_UID/g" "${ROOT}/modules/php-fpm/docker-compose.yml";
else
    echo "Setting UID ($NEW_UID) to \"www-data\" user in Docker Sync configuration file ...";
    sedi "s/\${UID}/$NEW_UID/g" "${ROOT}/docker-sync.yml";
fi;

exit 0;