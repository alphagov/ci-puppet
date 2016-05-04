#!/bin/sh

if ! /usr/lib/nagios/plugins/check_file_age -f /srv/logs/log-1/cdn/bouncer_and_redirector.log -c600 -w300 > /dev/null
then
    logger "ERROR: /srv/logs/log-1/cdn/bouncer_and_redirector.log is older than 5mins. Restarting rsyslog..."
    sudo service rsyslog restart
fi
