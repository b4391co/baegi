FROM mattrayner/lamp:latest

RUN apt-get update && apt-get -y install php-intl \
    && echo "xdebug.remote_enable=on" >> /etc/php/8.0/apache2/conf.d/zz-xdebug.ini \
    && echo "xdebug.remote_host=172.17.0.1" >> /etc/php/8.0/apache2/conf.d/zz-xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /etc/php/8.0/apache2/conf.d/zz-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /etc/php/8.0/apache2/conf.d/zz-xdebug.ini \
    && echo "xdebug.idekey=VSCODE" >> /etc/php/8.0/apache2/conf.d/zz-xdebug.ini

EXPOSE 9000
CMD ["/run.sh"]