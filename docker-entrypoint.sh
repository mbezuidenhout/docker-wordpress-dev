#!/bin/bash
set -euo pipefail

if [ -n "${MAILHOG_HOST:-}" ]; then
    echo "sendmail_path = /usr/bin/mhsendmail --smtp-addr $MAILHOG_HOST:1025" > /usr/local/etc/php/conf.d/mailhog.ini
fi

exec apache-run.sh "$@"
