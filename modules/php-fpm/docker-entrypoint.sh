#!/bin/sh

usermod -u $UID www-data;
chown -R www-data:www-data /var/www/html;

exec php-fpm;