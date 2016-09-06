# == Class: ci_environment::jenkins_job_support::postgresql
# Installs postgresql on the server
class ci_environment::jenkins_job_support::postgresql (
  $mapit_role_password,
) {
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
      password_hash => postgresql_password('mapit', $mapit_role_password);
  }

  if $::lsbdistcodename == 'trusty' {
    apt::source { 'postgresql':
      location     => 'http://apt.publishing.service.gov.uk/postgresql',
      release      => "${::lsbdistcodename}-pgdg",
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
      include_src  => false,
    }
  }
}
