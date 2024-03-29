#!/bin/bash
set -euo pipefail

# Composer install
EXPECTED_CHECKSUM="$(curl -Lsf https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
rm composer-setup.php
mv composer.phar /usr/local/bin
chmod +x /usr/local/bin/composer.phar
# End composer install

# Golang install
case $(uname -m) in
    i386) ;&
    i686)   curl -Lsf 'https://golang.org/dl/go1.21.1.linux-386.tar.gz' | tar -C '/usr/local' -xvzf - ;;
    x86_64) curl -Lsf 'https://golang.org/dl/go1.21.1.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf - ;;
    armv6l) ;&
    armv7l) curl -Lsf 'https://golang.org/dl/go1.21.1.linux-armv6l.tar.gz' | tar -C '/usr/local' -xvzf - ;;
    aarch64)  curl -Lsf 'https://golang.org/dl/go1.21.1.linux-arm64.tar.gz' | tar -C '/usr/local' -xvzf - ;;
    ppc64le)  curl -Lsf 'https://golang.org/dl/go1.21.1.linux-ppc64le.tar.gz' | tar -C '/usr/local' -xvzf - ;;
    s390x)  curl -Lsf 'https://golang.org/dl/go1.21.1.linux-s390x.tar.gz' | tar -C '/usr/local' -xvzf - ;;
esac
# End golang insall

# Mailhog client install
PATH=/usr/local/go/bin:$PATH
sleep 5
go get github.com/mailhog/mhsendmail && cp ~/go/bin/mhsendmail /usr/local/bin/
# End mailhog install

# Wordpress CLI install
curl -Lsf 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar' -o '/usr/local/bin/wp' && chmod +x '/usr/local/bin/wp'
# End Wordpress CLI install
