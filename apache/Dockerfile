FROM php:7.1-apache

ENV TERM=xterm

# installs composer, Node.js (+ npm) and some useful libraries
RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer \
    && chown www-data: /var/www \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        cron \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && ln -s /usr/bin/nodejs /usr/local/bin/node \
    && ln -s /usr/bin/npm /usr/local/bin/npm \
    && a2enmod rewrite

# installs php dependencies
RUN docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install opcache \
    && docker-php-ext-install pdo_mysql \
    && pecl install apcu \
    && pecl install xdebug

# enables cron
ADD crontab /tmp/
RUN crontab /tmp/crontab

# defines entry point
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]