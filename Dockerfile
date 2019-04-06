FROM ubuntu:16.04
MAINTAINER nsprng

RUN apt update && apt upgrade -y && apt install -y \
      git unzip apache2 apache2-bin libapache2-mod-fastcgi \
      libapache2-mod-php php7.0-mysql php7.0-imap \
      php7.0-gd php-mbstring phpunit mysql-client && \
    apt autoclean

COPY php7-fpm.conf /etc/apache2/conf-available

RUN phpenmod imap && \
    a2enmod actions fastcgi alias rewrite && \
    a2enconf php7-fpm

RUN git clone https://github.com/etsy/morgue.git && \
    cp -R morgue/ /var/www && \
    chown -R www-data:www-data /var/www/morgue && \
    cp -p /var/www/morgue/config/example.json /var/www/morgue/config/development.json && \
    rm -rf /morgue

RUN cd /var/www/morgue && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    php composer.phar remove phpunit/phpunit --dev && \
    php composer.phar require phpunit/phpunit --dev && \
    php composer.phar update

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY create_db.sql /var/www/morgue/schemas
COPY entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]
