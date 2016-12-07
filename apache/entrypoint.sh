#!/bin/bash

usermod -u ${USER_ID} www-data;
chown www-data:www-data /var/www/html;
chown -R www-data:www-data /var/www/html;
chmod g+rw -R $(ls /var/www/html | awk '{if($1 != "vendor"){ print $1 }}');

cron
exec /usr/sbin/apachectl -DFOREGROUND;