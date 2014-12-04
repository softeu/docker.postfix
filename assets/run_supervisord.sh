#!/bin/bash


/opt/install.sh;

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
