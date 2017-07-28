#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
ROOT=${DIR}/../..;

sedi()
{
    sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@";
}

# permissions issues workaround for Linux
if [ "$1" == "toolbox" ]; then
    sedi "s/\${UID}/$(id -u)/g" ${ROOT}/.docker/docker-compose-toolbox.yml;
else
    sedi "s/\${UID}/$(id -u)/g" ${ROOT}/.docker/docker-compose.yml;
fi;

exit 0;