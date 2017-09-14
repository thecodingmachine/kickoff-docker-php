#!/bin/sh

if ! /bin/sh -c "/scripts/health-check.sh PHP-FPM php-fpm 9000"; then
    exit 1;
fi;

if ! /bin/sh -c "/scripts/health-check.sh NGINX nginx 80"; then
    exit 1;
fi;

if [ "$MYSQL_ENABLED" == "false" ]; then
    echo Skipping MySQL and phpMyAdmin health check ...;
else
    if ! /bin/sh -c "/scripts/health-check.sh MySQL mysql 3306"; then
        exit 1;
    fi;

    if [ "$ENV" != "local" ]; then
        echo Skipping phpMyAdmin health check ...;
    elif ! /bin/sh -c "/scripts/health-check.sh phpMyAdmin phpmyadmin 80"; then
        exit 1;
    fi;
fi;

if [ "$REDIS_ENABLED" == "false" ]; then
    echo Skipping Redis health check ...;
elif ! /bin/sh -c "/scripts/health-check.sh Redis redis 6379"; then
    exit 1;
fi;

if [ "$RABBITMQ_ENABLED" == "false" ]; then
    echo Skipping RabbitMQ health check ...;
elif ! /bin/sh -c "/scripts/health-check.sh RabbitMQ rabbitmq 15672"; then
    exit 1;
fi;

exit 0;