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
# [*ssl_cert*]
# [*ssl_key*]
#   Absolute path to the ssl cert and key for the nginx vhost to use.
#
class ci_environment::jenkins_master (
  $github_enterprise_cert,
  $jenkins_servername,
  $jenkins_serveraliases = [],
  $ssl_cert = '/etc/ssl/certs/ssl-cert-snakeoil.pem',
  $ssl_key = '/etc/ssl/private/ssl-cert-snakeoil.key',
  $slave_user = 'slave',
  $jenkins_home
) {
  validate_string($github_enterprise_cert, $jenkins_servername, $jenkins_home)
  validate_array($jenkins_serveraliases)

  apt::source { 'govuk-jenkins':
    location     => 'http://apt.production.alphagov.co.uk/govuk-jenkins',
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    include_src  => false,
  }

  include java
  class { 'jenkins':
    repo => 0,
  }
  include jenkins_user
  include jenkins_job_support

  Class['java'] -> Class['jenkins'] -> Class['jenkins_user']
  Package <| title == 'jenkins' |> -> Jenkins::Plugin <| |>

  include nginx

  nginx::resource::vhost { $jenkins_servername:
    server_name      => flatten([$jenkins_servername, $jenkins_serveraliases]),
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

  jenkins::api_user { $slave_user: }
  jenkins::api_user { 'pingdom': }
  jenkins::api_user { 'github_build_trigger': }
  jenkins::api_user { 'deploy_jenkins': }

  file { "${jenkins_home}/hudson.plugins.warnings.WarningsPublisher.xml":
    ensure => 'present',
    source => 'puppet:///modules/ci_environment/hudson.plugins.warnings.WarningsPublisher.xml',
    notify => Class['jenkins::service'],
  }

}
