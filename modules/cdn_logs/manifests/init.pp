# == Class: cdn_logs
#
# rsyslog receiver for CDN access logs.
#
class cdn_logs (
  $port = 50514,
  $key,
  $key_file = '/etc/ssl/rsyslog.key',
  $cert,
  $cert_file = '/etc/ssl/rsyslog.crt',
  $log_dir = '/srv/logs/log-1/cdn',
) {
  file { $log_dir:
    ensure  => directory,
    owner   => 'syslog',
    group   => 'adm',
    mode    => '0775',
    require => Ext4mount[$log_dir],
  }

  file { $key_file:
    ensure  => file,
    content => $key,
    owner   => 'syslog',
    mode    => '0400',
    notify  => Class['rsyslog::service'],
  }
  file { $cert_file:
    ensure  => file,
    content => $cert,
    owner   => 'syslog',
    mode    => '0444',
    notify  => Class['rsyslog::service'],
  }

  rsyslog::snippet { '10-cdn_remote':
    content   => template('cdn_logs/etc/rsyslog.d/10-cdn_remote.conf.erb'),
    require   => [
      # Parent log dir and rsyslog configs.
      Class['ci_environment::transition_logs'],
      File[
        $key_file,
        $cert_file,
        $log_dir
      ]
    ],
  }

  rsyslog::snippet { 'transition_logs_sftp':
    content   => 'local7.*                       /var/log/sftp-server.log',
    require   => [
      Class['ci_environment::transition_logs']
    ]
  }

  ufw::allow { 'rsyslog_cdn_logs':
    port  => $port,
    ip    => 'any',
    proto => 'tcp',
  }

  # FIXME: once deployed this can be removed
  file { '/etc/logrotate.d/cdn_logs':
    ensure  => absent,
  }

  file { '/etc/logrotate.cdn_logs.conf':
    ensure  => file,
    content => template('cdn_logs/etc/logrotate.cdn_logs.conf.erb'),
  }

  file { '/etc/cron.hourly/cdn_logs_rotate':
    ensure  => file,
    content => template('cdn_logs/etc/cron.hourly/cdn_logs_rotate'),
    mode    => '0744',
    require => File['/etc/logrotate.cdn_logs.conf'],
  }

}
