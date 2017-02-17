#!/bin/bash

usermod -u ${USER_ID} -s /bin/bash www-data;

cron;
exec /usr/sbin/apachectl -DFOREGROUND;