# == Class: pact_broker
#
# Sets up and runs the pact-broker application
#
# === Parameters
#
# [*port*]
#   The port the application should run on
#
# [*vhost*]
#   The vhost name to configure in nginx
#
# [*ssl_cert*]
#   The ssl certificate file to use (relative to /etc/ssl)
#
# [*ssl_key*]
#   The ssl key file to use (relative to /etc/ssl)
#
# [*user*]
#   The user to run the app as
#
# [*deploy_dir*]
#   Where to deploy and run the app from
#
# [*db_user*]
# [*db_password*]
# [*db_name*]
#   The database user, password and database name to use.
#
# [*auth_user*]
# [*auth_password*]
#   The HTTP Basic Auth user and password to be configured for all write
#   requests (all non-GET requests) to the app.
#
class pact_broker (
  $port = 3112,
  $vhost = 'pact-broker',
  $ssl_cert = 'certs/ssl-cert-snakeoil.pem',
  $ssl_key = 'private/ssl-cert-snakeoil.key',
  $user = 'pact_broker',
  $deploy_dir = '/srv/pact_broker',
  $db_user = 'pact_broker',
  $db_password,
  $db_name = 'pact_broker',
  $auth_user = 'pact_ci',
  $auth_password,
) {

  # vHost
  nginx::vhost::proxy  { $vhost:
    ssl           => true,
    ssl_redirect  => true,
    ssl_cert      => $ssl_cert,
    ssl_key       => $ssl_key,
    magic         => 'add_header Strict-Transport-Security "max-age=31536000";',
    upstream_port => $port,
  }

  # User
  user { $user:
    home       => $deploy_dir,
    managehome => true,
  }

  # Application
  class { 'pact_broker::app':
    app_root      => "${deploy_dir}/app",
    user          => $user,
    db_user       => $db_user,
    db_password   => $db_password,
    db_name       => $db_name,
    auth_user     => $auth_user,
    auth_password => $auth_password,
    require       => User[$user],
  }

  # Database
  postgresql::server::db { $db_name:
    user     => $db_user,
    password => $db_password,
  }

  class { 'pact_broker::service':
    deploy_dir => $deploy_dir,
    user       => $user,
    port       => $port,
    subscribe  => Class['pact_broker::app'],
    require    => Postgresql::Server::Db[$db_name],
  }

  file { '/etc/logrotate.d/pact_broker':
    source => 'puppet:///modules/pact_broker/logrotate',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
