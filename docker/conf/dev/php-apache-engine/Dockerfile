FROM php:7-apache

# installs missing php dependencies
RUN pecl install apcu-5.1.5 \
    && pecl install xdebug-2.4.0 # (dev environment only!)

RUN apt-get update \
    && apt-get install -y zlib1g-dev # dependency for php zip extension

RUN docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip

# enables Apache's rewrite module
RUN a2enmod rewrite

# composer
RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer

# git
RUN apt-get update \
    && apt-get -y install git

# installs nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && ln -s /usr/bin/nodejs /usr/local/bin/node \
    && ln -s /usr/bin/npm /usr/local/bin/npm

# creates composer / npm user
RUN useradd --create-home --shell /bin/bash custom_user \
    && echo 'custom_user:admin' | chpasswd \
    && adduser custom_user sudo