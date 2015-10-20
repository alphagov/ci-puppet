# == Class: ci_environment::graphite_server
#
# Supporting configuration for the graphite server
#
# === Parameters
#
# [*ssl_cert*]
# [*ssl_key*]
#   Absolute path to the ssl cert and key for the nginx vhost to use.
#
class ci_environment::graphite_server (
  $ssl_cert = '/etc/ssl/certs/ssl-cert-snakeoil.pem',
  $ssl_key = '/etc/ssl/private/ssl-cert-snakeoil.key',
) {
  include graphite

  include nginx

  nginx::resource::vhost { 'graphite-nginx':
    listen_options   => 'default',
    proxy            => 'http://localhost:8000/',
    proxy_set_header => $::nginx::config::proxy_set_header, # Necessary until https://github.com/jfryman/puppet-nginx/pull/700 is released
    ssl              => true,
    rewrite_to_https => true,
    ssl_cert         => $ssl_cert,
    ssl_key          => $ssl_key,
    index_files      => [],
    add_header       => {'Strict-Transport-Security' => '"max-age=31536000"'},
  }
}
