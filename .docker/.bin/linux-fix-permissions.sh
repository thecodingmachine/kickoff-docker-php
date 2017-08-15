#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
ROOT=${DIR}/../..;

sedi()
{
    sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@";
}

# permissions issues workaround for Linux
sedi "s/\${UID}/$(id -u)/g" ${ROOT}/.docker/docker-compose.yml;
sedi "s/\${GID}/$(id -g)/g" ${ROOT}/.docker/docker-compose.yml;

exit 0;