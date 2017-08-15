#!/bin/sh

usermod -u $UID www-data;
groupmod -u $GID www-data;
chown -R www-data:www-data /var/www/html;
php-fpm;