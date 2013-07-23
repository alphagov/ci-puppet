# == Class: ci_environment::graphite_server
#
# Supporting configuration for the graphite server
#
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
        isdefaultvhost => true,
        upstream_port  => 8000,
    }

    ufw::allow {'collectd-listening-for-data':
        port  => '2003',
        ip    => 'any',
        proto => 'tcp',
    }
    ufw::allow {'https':
        port  => '443',
        ip    => 'any',
        proto => 'tcp',
    }
}
