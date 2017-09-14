#!/bin/sh

if [ "$GRAYLOG_ENABLED" == "false" ]; then
    echo Skipping Graylog health check ...;
    exit 0;
fi;

if ! /bin/sh -c "/scripts/health-check.sh Graylog graylog-server 9000"; then
    exit 1;
fi;

exit 0;