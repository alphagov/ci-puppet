# == Class: ci_environment::base
#
# Class applied to all CI machines
#
class ci_environment::base {
  apt::ppa { 'ppa:gds/govuk': }
  apt::ppa { 'ppa:gds/ci': }

  include ci_environment::fail2ban
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
    'mercurial',
    'pv',
    'tar',
    'tree',
    'unzip',
    'vim-nox',
    'xz-utils',
    'zip',
  ])

  rbenv::version { '1.9.3-p392':
    bundler_version => '1.6.5'
  }
  rbenv::version { '1.9.3-p484':
    bundler_version => '1.6.5'
  }
  rbenv::version { '1.9.3-p545':
    bundler_version => '1.6.5'
  }
  rbenv::alias { '1.9.3':
    to_version => '1.9.3-p545',
  }

  # FIXME remove once cleaned up everywhere
  package { 'rbenv-ruby-2.0.0-p247':
    ensure => purged,
  }
  rbenv::version { '2.0.0-p353':
    bundler_version => '1.6.5'
  }
  rbenv::version { '2.0.0-p451':
    bundler_version => '1.5.3'
  }
  rbenv::alias { '2.0.0':
    to_version => '2.0.0-p451',
  }

  rbenv::version { '2.1.2':
    bundler_version => '1.6.5',
  }
  rbenv::alias { '2.1':
    to_version => '2.1.2',
  }
  package { 'rbenv-ruby-2.1.1':
    ensure => absent,
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

  include ssh::server

  $latest_lte_supported = 'trusty'
  # Force us to a kernel that is 'supported', requires a reboot to be certain
  package {["linux-generic-lts-${latest_lte_supported}", "linux-image-generic-lts-${latest_lte_supported}", 'update-manager-core']:
    ensure  => present,
  }

  exec { 'apt-get-update':
    command => '/usr/bin/apt-get update || true',
  }
  Exec <| title == 'apt-get-update' |> -> Package <| provider == 'apt' |>
}
