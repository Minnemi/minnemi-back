# Use PHP 8.1 with Apache as the base image
FROM php:8.1-apache

# Update repositories, install dependencies, and clean downloaded packages
RUN apt-get update \
    && apt-get -y install curl git zip zlib1g-dev libzip-dev \
    && apt-get clean

# Install necessary PHP extensions
RUN docker-php-ext-install mysqli pdo_mysql zip

# Copy the application files into the container
COPY . /var/www/html

# Copy composer.json and composer.lock to the /var/www/html directory in the container
COPY composer.json composer.lock /var/www/html/

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install Composer dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --optimize-autoloader --no-scripts

# Set the environment variable for the Apache document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Update Apache configuration to use the specified document root
RUN sed -i "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/000-default.conf
RUN sed -i "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/default-ssl.conf

# Volume to store logs outside the container
VOLUME ["/var/www/html/storage/logs"]

# Execute Artisan commands and adjust permissions
RUN php artisan cache:clear && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan key:generate && \
    php artisan jwt:secret && \
    php artisan schedule:work

# Set write permissions for the storage directory
RUN chmod -R 777 storage
RUN chown -R www-data:www-data storage

# Enable the Apache rewrite module
RUN a2enmod rewrite

# Expose port 80 to allow external access to the web server
EXPOSE 80

