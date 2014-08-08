# == Class: ci_environment::jenkins_job_support::postgresql
# Installs postgresql on the server
class ci_environment::jenkins_job_support::postgresql {
  include postgresql::server
  include postgresql::server::contrib
  include postgresql::lib::devel

  $transition_password = postgresql_password('transition', 'transition')
  $url_arbiter_password = postgresql_password('url-arbiter', 'url-arbiter')

  postgresql::server::role {
    'jenkins':
      password_hash => postgresql_password('jenkins', 'jenkins'),
      createdb      => true;
  }
}
