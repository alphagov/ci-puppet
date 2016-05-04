#!/bin/sh
logger='/usr/bin/logger'
service='/usr/sbin/service'
check_file_age='/usr/lib/nagios/plugins/check_file_age'
log_file='/srv/logs/log-1/cdn/bouncer_and_redirector.log'

if ! $check_file_age -f $log_file -c600 -w300 > /dev/null
then
    $logger "ERROR: /srv/logs/log-1/cdn/bouncer_and_redirector.log is older than 5mins. Restarting rsyslog..."
    $service rsyslog restart
fi
