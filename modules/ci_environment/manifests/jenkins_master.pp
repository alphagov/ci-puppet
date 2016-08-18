# == Class: ci_environment::jenkins_master
#
# Class to install things only on the Jenkins Master
#
# See opsmanual for manual steps:
#
# https://github.gds/pages/gds/opsmanual \
#   /infrastructure/howto/configuring-ci-environment-and-machines.html
#
# === Parameters
#
# [*github_enterprise_cert*]
#   Auth cert for github enterprise.
#
# [*vhost*]
#   The vhost name for the Jenkins web UI
#
# [*ssl_cert*]
# [*ssl_key*]
#   Absolute path to the ssl cert and key for the nginx vhost to use.
#
# [*legacy_...*]
#   Legacy vhosts and SSL certs to be support the migration to the new domain
#
# [*jenkins_home*]
#   Jenkin's user base/home directory.
#   Default: /var/lib/jenkins
#
# [*users_dir*]
#   Directory that Jenkins keeps it's user configs. The default should be
#   fine for installations from the official packages.
#   Default: /var/lib/jenkins/users
#
# [*slave_user*]
#   The account used by slave instances to authenticate with Jenkins master.
#
class ci_environment::jenkins_master (
  $github_enterprise_cert,
  $vhost,
  $ssl_cert = '/etc/ssl/certs/ssl-cert-snakeoil.pem',
  $ssl_key = '/etc/ssl/private/ssl-cert-snakeoil.key',
  $legacy_vhost = undef,
  $legacy_vhost_ssl_cert = '/etc/ssl/certs/ssl-cert-snakeoil.pem',
  $legacy_vhost_ssl_key = '/etc/ssl/private/ssl-cert-snakeoil.key',
  $slave_user = 'slave',
  $jenkins_home,
  $users_dir = '/var/lib/jenkins/users'
) {
  validate_string($github_enterprise_cert, $vhost, $jenkins_home)

  apt::source { 'govuk-jenkins':
    location     => 'http://apt.production.alphagov.co.uk/govuk-jenkins',
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    include      => { 'src' => false },
  }

  include java
  class { 'jenkins':
    repo => false,
  }
  include jenkins_user

  Package <| title == 'jenkins' |> -> Jenkins::Plugin <| |>

  include nginx

  nginx::resource::vhost { $vhost:
    listen_options   => 'default',
    proxy            => 'http://localhost:8080/',
    proxy_set_header => $::nginx::config::proxy_set_header, # Necessary until https://github.com/jfryman/puppet-nginx/pull/700 is released
    ssl              => true,
    rewrite_to_https => true,
    ssl_cert         => $ssl_cert,
    ssl_key          => $ssl_key,
    index_files      => [],
    add_header       => {'Strict-Transport-Security' => '"max-age=31536000"'},
  }

  # The legacy_vhost is a redirect from the 'alphagov' domain to the ci 'publishing.service'.
  if $legacy_vhost != undef {
    nginx::resource::vhost { $legacy_vhost:
      proxy            => 'http://localhost:8080/',
      proxy_set_header => $::nginx::config::proxy_set_header, # Necessary until https://github.com/jfryman/puppet-nginx/pull/700 is released
      ssl              => true,
      rewrite_to_https => true,
      ssl_cert         => $legacy_vhost_ssl_cert,
      ssl_key          => $legacy_vhost_ssl_key,
      index_files      => [],
      add_header       => {'Strict-Transport-Security' => '"max-age=31536000"'},
    }
  }

  file {'/etc/ssl/certs/github.gds.pem':
    ensure  => 'present',
    content => $github_enterprise_cert,
    notify  => Exec['import-github-cert'],
  }

  exec {'import-github-cert':
    command => '/usr/bin/keytool -import -trustcacerts -alias github.gds \
                -file /etc/ssl/certs/github.gds.pem \
                -keystore /etc/ssl/certs/java/cacerts \
                -storepass changeit -noprompt',
    unless  => '/usr/bin/keytool -list \
                -keystore /etc/ssl/certs/java/cacerts \
                -storepass changeit | grep github.gds',
  }

  file { $users_dir :
    ensure => directory,
    owner  => 'jenkins',
  } ->

  ci_environment::api_user { [
    $slave_user,
    'pingdom',
    'github_build_trigger',
    'deploy_jenkins',
  ] : }

  file { "${jenkins_home}/hudson.plugins.warnings.WarningsPublisher.xml":
    ensure => 'present',
    source => 'puppet:///modules/ci_environment/hudson.plugins.warnings.WarningsPublisher.xml',
    notify => Class['jenkins::service'],
  }

}
