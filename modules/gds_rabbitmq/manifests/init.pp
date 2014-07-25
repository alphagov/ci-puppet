# == Class: gds_rabbitmq
#
# Wraps the puppetlabs rabbitmq module and installs from our apt repo
class gds_rabbitmq (
  $root_password = 'root',
) {
  include gds_rabbitmq::repo

  class { '::rabbitmq':
    manage_repos => false,
  }

  rabbitmq_user { 'root':
    admin    => true,
    password => $root_password,
  }

  rabbitmq_user_permissions { 'root@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}
