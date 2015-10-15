# == Class: pact_broker::service
#
# Configure the pact-broker service
#
class pact_broker::service (
  $deploy_dir,
  $user,
  $port,
) {

  file { "${deploy_dir}/unicorn.rb":
    owner   => $user,
    mode    => '0644',
    content => template('pact_broker/unicorn.rb.erb'),
    notify  => Service['pact-broker'],
  }

  file { '/etc/init/pact-broker.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pact_broker/upstart.conf.erb'),
    notify  => Service['pact-broker'],
  }

  service { 'pact-broker':
    ensure => running,
    enable => true,
  }
}
