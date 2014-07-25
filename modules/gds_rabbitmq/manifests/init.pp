# == Class: gds_rabbitmq
#
# Wraps the puppetlabs rabbitmq module and installs from our apt repo
class gds_rabbitmq {
  include gds_rabbitmq::repo

  class { '::rabbitmq':
    manage_repos => false,
  }
}
