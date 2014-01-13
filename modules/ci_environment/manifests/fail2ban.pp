# == Class: ci_environment::fail2ban
#
# Installs fail2ban for IP blacklisting
#
class ci_environment::fail2ban(
  $whitelist_ips = ['127.0.0.1'],
) {
  class { '::fail2ban':
    require => Exec['apt-get-update']
  }

  file { '/etc/fail2ban/jail.local':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ci_environment/etc/fail2ban/jail.local.erb'),
    notify  => Service['fail2ban'],
    # Require package rather than class to avoid dependency issues
    # incurred by the Fail2Ban module we are using.
    require => Package['fail2ban'],
  }
}
