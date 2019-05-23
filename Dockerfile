FROM bezuidenhout/wordpress
MAINTAINER Marius Bezuidenhout "marius.bezuidenhout@gmail.com"

RUN apt-get update &&\
    apt-get install --no-install-recommends --assume-yes --quiet ca-certificates subversion &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    ldconfig

# Install xdebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.default_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable_trigger=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_dir=/var/www/html" >> /usr/local/etc/php/conf.d/xdebug.ini

# Install mailhog
RUN curl -Lsf 'https://dl.google.com/go/go1.11.2.linux-armv6l.tar.gz' | tar -C '/usr/local' -xvzf -
ENV PATH /usr/local/go/bin:$PATH
RUN go get github.com/mailhog/mhsendmail &&\
    cp /root/go/bin/mhsendmail /usr/bin/mhsendmail &&\
    echo 'sendmail_path = /usr/bin/mhsendmail --smtp-addr mailhog:1025' > /usr/local/etc/php/conf.d/mailhog.ini

# Adding WordPress CLI
RUN curl -Lsf 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar' -o '/usr/local/bin/wp' && chmod +x '/usr/local/bin/wp'

# Adding Composer
RUN curl -Lsf 'https://getcomposer.org/download/1.8.5/composer.phar' -o '/usr/local/bin/composer' && chmod +x '/usr/local/bin/composer'

# Adding PHPunit
RUN curl -Lsf 'https://phar.phpunit.de/phpunit-7.5.phar' -o '/usr/local/bin/phpunit' && chmod -x '/usr/local/bin/phpunit'
