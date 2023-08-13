# Imagem base
FROM php:8.1-apache

# Atualiza repositórios, instala dependências e limpa pacotes baixados
RUN apt-get update \
    && apt-get -y install curl git zip zlib1g-dev libzip-dev \
    && apt-get clean

# Instala extensões PHP necessárias
RUN docker-php-ext-install mysqli pdo_mysql zip

# Copia os arquivos do aplicativo
COPY . /var/www/html

# Copia o composer.json e o composer.lock para o diretório /var/www/html no contêiner
COPY composer.json composer.lock /var/www/html/

# Define o diretório de trabalho como /var/www/html
WORKDIR /var/www/html

# Instala as dependências do Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --optimize-autoloader --no-scripts

# Variável de ambiente para o diretório raiz do Apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Atualiza configurações do Apache para usar o diretório raiz especificado
RUN sed -i "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/000-default.conf
RUN sed -i "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/default-ssl.conf

# Volume para armazenar logs fora do contêiner
VOLUME ["/var/www/html/storage/logs"]

# Executa os comandos Artisan e ajustes de permissões
RUN php artisan cache:clear && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan key:generate

# Define permissões de escrita para o diretório de armazenamento
RUN chmod -R 777 storage
RUN chown -R www-data:www-data storage

# Habilita o módulo rewrite do Apache
RUN a2enmod rewrite

# Expõe a porta 80
EXPOSE 80