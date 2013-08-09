# == Class: ci_environment::base
#
# Class applied to all CI machines
#
class ci_environment::base {
  include harden
  include github_sshkeys

  file { '/etc/sudoers.d/gds':
    ensure  => present,
    mode    => '0440',
    content => '%gds ALL=(ALL) NOPASSWD: ALL
'
  }

  file { '/etc/ssh/ssh_known_hosts':
    ensure  => present,
    mode    => '0644',
  }

  class { 'fail2ban':
    require => Exec['apt-get-update']
  }

  include ssh::server

  exec { 'apt-get-update':
    command => '/usr/bin/apt-get update || true',
  }
  Exec <| title == 'apt-get-update' |> -> Package <| provider == 'apt' |>
}
