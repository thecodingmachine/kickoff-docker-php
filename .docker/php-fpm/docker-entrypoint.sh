#!/bin/sh

usermod -u $UID www-data;
chown -R www-data:www-data /var/www/html;
php-fpm;