#!/bin/bash

chgrp www-data /var/www/html;
chgrp -R www-data /var/www/html;
chmod g+rw -R $(ls /var/www/html | awk '{if($1 != "vendor"){ print $1 }}');

exec /usr/sbin/apachectl -DFOREGROUND;