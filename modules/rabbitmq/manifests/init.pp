# == Class: rabbitmq
#
# Installs and starts rabbitmq-server
class rabbitmq {

  package { 'rabbitmq-server':
    ensure => present,
    name   => 'rabbitmq-server',
  }

  service { 'rabbitmq-server':
    ensure  => running,
    require => Package['rabbitmq-server'],
  }

}
