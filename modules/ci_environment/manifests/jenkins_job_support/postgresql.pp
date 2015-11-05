# == Class: ci_environment::jenkins_job_support::postgresql
# Installs postgresql on the server
class ci_environment::jenkins_job_support::postgresql {
  include postgresql::server
  include postgresql::server::contrib
  include postgresql::lib::devel

  postgresql::server::role {
    'jenkins':
      password_hash => postgresql_password('jenkins', 'jenkins'),
      createdb      => true;
  }

  # For mapit
  class { 'postgresql::server::postgis': }

  # The mapit role needs to be a superuser in order to load the PostGIS
  # extension for the test database.
  postgresql::server::role {
    'mapit':
      superuser     => true,
      password_hash => postgresql_password('mapit', 'mapit');
  }

}
