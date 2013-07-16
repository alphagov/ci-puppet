#supporting configuration for the graphite server
class ci_environment::graphite_server {
    include graphite

    package {'ssl-cert':
      ensure  => latest,
      require => Exec['apt-get-update'],
    }

    class {'nginx::server':
      require => Package['ssl-cert'],
    }

    nginx::vhost::proxy  {'graphite-nginx':
        ssl            => true,
        ssl_redirect   => true,
        isdefaultvhost => true,
        upstream_port  => 8000,
    }
}
