# == Class: ci_environment::graphite_server
#
# Supporting configuration for the graphite server
#
class ci_environment::graphite_server {
  include graphite

  package {'ssl-cert':
    ensure  => latest,
  }

  class {'nginx::server':
    require => Package['ssl-cert'],
  }

  nginx::vhost::proxy  {'graphite-nginx':
    ssl            => true,
    isdefaultvhost => true,
    upstream_port  => 8000,
  }
}
