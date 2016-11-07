FROM php:7-apache

# installs missing php dependencies
RUN pecl install apcu-5.1.5

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
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    ln -s /usr/bin/nodejs /usr/local/bin/node && \
    ln -s /usr/bin/npm /usr/local/bin/npm

# s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

ENTRYPOINT ["/init"]
