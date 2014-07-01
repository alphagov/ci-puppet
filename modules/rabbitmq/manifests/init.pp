# == Class: rabbitmq
#
# Installs and starts rabbitmq-server
class rabbitmq {
  include rabbitmq::repo

  package { 'rabbitmq-server':
    ensure => '3.3.4-1',
    name   => 'rabbitmq-server',
  }

  service { 'rabbitmq-server':
    ensure  => running,
    require => Package['rabbitmq-server'],
  }

}
