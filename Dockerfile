#
# Dockerfile for WordPress development
#

FROM bezuidenhout/wordpress:apache
LABEL maintainer="Marius Bezuidenhout <marius.bezuidenhout@gmail.com>"

RUN apt-get update &&\
    apt-get install --no-install-recommends --assume-yes --quiet ca-certificates subversion mariadb-client &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    ldconfig

COPY installer.sh /usr/local/bin/

# Install mailhog client, composer, WordPress CLI and xdebug and set development parameters
RUN chmod +x /usr/local/bin/installer.sh \
    && /usr/local/bin/installer.sh \
    && yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && sed -ri -e "s/^display_errors.*$/display_errors = On/" /usr/local/etc/php/conf.d/error-logging.ini \
    && sed -ri -e "s/^html_errors.*$/html_errors = On/" /usr/local/etc/php/conf.d/error-logging.ini \
    && sed -ri -e "s/^display_startup_errors.*$/display_startup_errors = On/" /usr/local/etc/php/conf.d/error-logging.ini

#RUN curl -Lsf 'https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
#ENV PATH /usr/local/go/bin:$PATH
#RUN go get github.com/mailhog/mhsendmail &&\
#    cp /root/go/bin/mhsendmail /usr/bin/mhsendmail &&\
#    echo 'sendmail_path = /usr/bin/mhsendmail --smtp-addr mailhog:1025' > /usr/local/etc/php/conf.d/mailhog.ini

# Adding WordPress CLI
#RUN curl -Lsf 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar' -o '/usr/local/bin/wp' && chmod +x '/usr/local/bin/wp'

# Adding Composer
#RUN curl -Lsf 'https://getcomposer.org/download/1.8.5/composer.phar' -o '/usr/local/bin/composer' && chmod +x '/usr/local/bin/composer'

# Adding PHPunit
RUN curl -Lsf 'https://phar.phpunit.de/phpunit-7.5.phar' -o '/usr/local/bin/phpunit' && chmod -x '/usr/local/bin/phpunit'

# Move old docker-entrypoint.sh
RUN mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/apache-run.sh

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
