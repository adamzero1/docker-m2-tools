#!/bin/sh
# Start services
service rsyslog start
service postfix start

watch -n 60 "ls"

su --login www-data --shell=/bin/bash
cd /usr/share/nginx/html
