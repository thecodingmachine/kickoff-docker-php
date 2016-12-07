#!/bin/bash

usermod -u ${USER_ID} www-data;
chgrp www-data /var/www/html;
chgrp -R www-data /var/www/html;
chmod g+rw -R $(ls /var/www/html | awk '{if($1 != "vendor"){ print $1 }}');

(inotifywait -m -r /var/www/html -e create --format '%w%f' | while read f; do chown $(stat -c '%u' /var/www/html):$(stat -c '%g' /var/www/html) $f; done &);

cron;
exec /usr/sbin/apachectl -DFOREGROUND;