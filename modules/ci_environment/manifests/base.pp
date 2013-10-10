# == Class: ci_environment::base
#
# Class applied to all CI machines
#
class ci_environment::base {
  apt::ppa { 'ppa:gds/govuk': }
  apt::ppa { 'ppa:gds/ci': }

  include harden
  include github_sshkeys
  include rbenv

  ensure_packages([
    'ack-grep',
    'bzip2',
    'gettext',
    'htop',
    'iftop',
    'iotop',
    'dstat',
    'iptraf',
    'less',
    'libc6-dev',
    'libcurl4-openssl-dev',
    'libreadline-dev',
    'libreadline5',
    'libsqlite3-dev',
    'libxml2-dev',
    'libxslt1-dev',
    'logtail',
    'lsof',
    'pv',
    'tar',
    'tree',
    'unzip',
    'vim-nox',
    'xz-utils',
    'zip',
  ])

  rbenv::version { '1.9.3-p392':
    bundler_version => '1.3.5'
  }

  rbenv::alias { '1.9.3':
    to_version => '1.9.3-p392',
  }

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
