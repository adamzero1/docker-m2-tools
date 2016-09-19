#!/bin/sh
# Start services
service rsyslog start
service postfix start

su --login www-data --shell=/bin/bash
cd /usr/share/nginx/html
