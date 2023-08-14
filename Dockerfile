FROM php:8.1-apache

WORKDIR /var/www/html/

RUN apt-get update \
    && apt-get -y install curl git zip zlib1g-dev libzip-dev \
    && apt-get clean

RUN docker-php-ext-install mysqli pdo_mysql zip

COPY . .

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -i "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/000-default.conf
RUN sed -i "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/default-ssl.conf

RUN a2enmod rewrite

VOLUME ["/var/www/html/storage/logs"]

EXPOSE 80
