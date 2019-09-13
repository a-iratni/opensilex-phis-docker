FROM php:7.1-apache

RUN apt-get update && apt-get install -y libxml2 libxml2-dev zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev curl git unzip
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-install mbstring

# Composer
RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data /var/www

ARG VERSION=3.2.1
ARG PHIS_WEBAPP_PLATFORM=opensilex

USER www-data
WORKDIR /var/www/html

RUN git clone -b $VERSION https://github.com/OpenSILEX/phis-webapp.git $PHIS_WEBAPP_PLATFORM

WORKDIR /var/www/html/$PHIS_WEBAPP_PLATFORM
RUN sed -i 's/\x27phis-webapp\x27/getenv\("PHIS_WEBAPP_PLATFORM"\)/g' config/config.php
RUN sed -i 's/\x27localhost\x27/getenv\("PHIS_WEBAPP_HOST"\) \. \x27:\x27 \. getenv\("PHIS_WEBAPP_PORT"\)/g' config/config.php
RUN sed -i 's/\x27Demo\x27/getenv\("PHIS_WEBAPP_NAME"\)/g' config/params.php
RUN sed -i 's/\x27WS_PHIS_PATH\x27\x2C \x27http:\/\/localhost:8080\/opensilex/\x27WS_PHIS_PATH\x27\x2C getenv\("PHIS_WS_URL"\) \. \x27/g' config/web_services.php
RUN sed -i 's/\x27WS_PHIS_PATH_DOC\x27\x2C \x27http:\/\/localhost:8080\/opensilex/\x27WS_PHIS_PATH_DOC\x27\x2C getenv\("PHIS_WS_DOC_URL"\) \. \x27/g' config/web_services.php

RUN composer install --ignore-platform-reqs

USER root