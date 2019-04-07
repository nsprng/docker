FROM ubuntu:16.04
MAINTAINER nsprng

#Update system and install packages
RUN apt update && apt upgrade -y && apt install -y \
      git unzip apache2 apache2-bin libapache2-mod-fastcgi \
      libapache2-mod-php php7.0-mysql php7.0-imap \
      php7.0-gd php-mbstring phpunit mysql-client && \
    apt autoclean

#Copy FPM module config
COPY php7-fpm.conf /etc/apache2/conf-available

#Enable modules
RUN phpenmod imap && \
    a2enmod actions fastcgi alias rewrite && \
    a2enconf php7-fpm

#Download Morgue 
RUN git clone https://github.com/etsy/morgue.git && \
    cp -R morgue/ /var/www && \
    chown -R www-data:www-data /var/www/morgue && \
    cp -p /var/www/morgue/config/example.json /var/www/morgue/config/development.json && \
    rm -rf /morgue

#Install PHP composer and PHPUnit
RUN cd /var/www/morgue && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    php composer.phar remove phpunit/phpunit --dev && \
    php composer.phar require phpunit/phpunit --dev && \
    php composer.phar update

#Copy Apache config
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
#Create DB user and schema 
COPY create_db.sql /var/www/morgue/schemas
#Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh

#Apache will listen on port 80
EXPOSE 80

#Run script to make some preparations
ENTRYPOINT ["/entrypoint.sh"]
#Start Apache
CMD ["apachectl", "-D", "FOREGROUND"]
