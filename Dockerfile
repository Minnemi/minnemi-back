FROM php:8.1-apache

ARG enviroment='teste'

RUN apt-get update && apt-get -y install curl git zip zlib1g-dev libzip-dev && apt-get clean

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

VOLUME ["/var/www/html/storage/logs"]

RUN docker-php-ext-install mysqli pdo_mysql zip

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && rm composer-setup.php && mv composer.phar /usr/local/bin/composer && chmod a+x /usr/local/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN a2enmod ssl && a2enmod rewrite

#ONLY FOR LOCAL ENVIROMENT
#RUN mkdir -p /etc/apache2/ssl
#COPY ./local-cert/*.pem /etc/apache2/ssl/
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit=1024M' >> /usr/local/etc/php/conf.d/docker-php-memory-limit.ini && \
  echo 'post_max_size=256M' >> /usr/local/etc/php/conf.d/docker-php-post-limit.ini &&\
  echo 'upload_max_size=256M' >> /usr/local/etc/php/conf.d/docker-php-upload-limit.ini

#ENV PHP_MEMORY_LIMIT=128M
#ENV PHP_POST_LIMIT=128M

#COPY ./apache/000-default.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

#Copy files
#Local
COPY . /var/www/html/.

#GIT
#RUN git clone https://github.com/Software-Start/Back_Sistema_Limpe_Ja.git

RUN chmod o+w ./storage/ -R

#Installation commands
#Local
#RUN cp .env.local .env

#Development/Test
#RUN cp .env.${enviroment} .env

#Production
#RUN cp .env.prod .env

RUN composer install

RUN php artisan cache:clear && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan key:generate && \
    chmod 777 -R /var/www/html/storage/ && \
    chown -R www-data:www-data /var/www/ && \
    a2enmod rewrite

#Development/Test
#RUN php artisan migrate:refresh --seed

#Production
#RUN php artisan migrate:refresh

EXPOSE 80

#If necessary
#EXPOSE 443
