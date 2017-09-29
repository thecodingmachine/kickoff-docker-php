#!/bin/sh

SERVICE=$1;
HOST=$2;
PORT=$3;

spin='-\|/';
i=0;

attempts=6000;
while [ $attempts -ne 0 ]; do

    nc -z $HOST $PORT > /dev/null 2>&1;

    if [ $? -eq 0 ]; then
        printf "\r[OK] $SERVICE is running!\n";
        exit 0;
    fi;

    i=$(( (i+1) %4 ));
    printf "\r${spin:$i:1} Waiting $SERVICE ...";
    sleep .1

    attempts=`expr $attempts - 1`;
done;

printf "\r[error] $SERVICE failed to launch!\n";
exit 1;