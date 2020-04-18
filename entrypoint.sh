#!/bin/sh
# Inspired by https://github.com/influxdata/influxdata-docker/blob/master/telegraf/1.14/alpine/entrypoint.sh
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- telegraf "$@"
fi

exec "$@"
