#!/bin/sh

echo Waiting Graylog ...;

attempts=30;
while [[ $attempts -ne 0 ]]; do
    nc -z graylog-server 9000 > /dev/null 2>&1;
    if [[ $? -eq 0 ]]; then
       exit 0;
    fi;
    sleep 5s;
    attempts=`expr $attempts - 1`;
    echo .;
done;

echo Graylog has not started, aborting other containers startup ...;
exit 1;