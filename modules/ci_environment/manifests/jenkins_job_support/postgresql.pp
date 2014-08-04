# == Class: ci_environment::jenkins_job_support::postgresql
# Installs postgresql on the server
class ci_environment::jenkins_job_support::postgresql {
  include postgresql::server
  include postgresql::server::contrib
  include postgresql::lib::devel

  postgresql::server::db { 'transition_test':
    encoding => 'UTF8',
    owner    => 'transition',
    password => postgresql_password('transition', 'transition'),
    user     => 'transition',
  }

  exec { 'Load pgcrypto for postgres db transition_test':
    user    => 'postgres',
    command => 'psql -d transition_test -c "CREATE EXTENSION IF NOT EXISTS pgcrypto"',
    unless  => 'psql -d transition_test -c "\dx" | grep -q pgcrypto',
    require => Postgresql::Server::Db['transition_test'],
  }
}
