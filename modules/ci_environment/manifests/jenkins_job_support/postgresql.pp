# == Class: ci_environment::jenkins_job_support::postgresql
# Installs postgresql on the server
class ci_environment::jenkins_job_support::postgresql {
  include postgresql::server
  include postgresql::server::contrib
  include postgresql::lib::devel

  $transition_password = postgresql_password('transition', 'transition')

  postgresql::server::role { 'transition':
    password_hash => $transition_password,
  }

  postgresql::server::db { 'transition_test':
    encoding => 'UTF8',
    owner    => 'transition',
    password => $transition_password,
    user     => 'transition',
    require  => [Class['postgresql::server'], Postgresql::Server::Role['transition']],
  }

  exec { 'Load pgcrypto for postgres db transition_test':
    user    => 'postgres',
    command => 'psql -d transition_test -c "CREATE EXTENSION IF NOT EXISTS pgcrypto"',
    unless  => 'psql -d transition_test -c "\dx" | grep -q pgcrypto',
    require => Postgresql::Server::Db['transition_test'],
  }
}
