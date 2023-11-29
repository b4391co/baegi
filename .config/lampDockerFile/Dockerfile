FROM php:8.1-apache

# Define variables de entorno
ENV XDEBUG_MODE=debug \
    XDEBUG_START_WITH_REQUEST=yes \
    XDEBUG_CLIENT_HOST=host.docker.internal \
    XDEBUG_CLIENT_PORT=9003

# Instala las extensiones necesarias de PHP
RUN docker-php-ext-install mysqli pdo_mysql


# Instala Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Instala el controlador MongoDB para PHP
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

RUN mkdir -p /data/db

# Configura Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN echo "<VirtualHost *:80>\n\
    DocumentRoot /var/www/html\n\
    <Directory /var/www/html>\n\
        AllowOverride All\n\
        Require all granted\n\
        Options Indexes FollowSymLinks\n\
    </Directory>\n\
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

# Configura Xdebug
RUN echo "xdebug.mode=debug\n\
xdebug.start_with_request=yes\n\
xdebug.client_host=172.20.0.1" > /usr/local/etc/php/conf.d/xdebug.ini

# Configura MongoDB
RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini

# Expone el puerto 80
EXPOSE 80
