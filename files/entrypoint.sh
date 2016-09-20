#!/bin/sh
# Start services
service rsyslog start
service postfix start

tail -f -n0 /etc/hosts

su --login www-data --shell=/bin/bash
cd /usr/share/nginx/html
