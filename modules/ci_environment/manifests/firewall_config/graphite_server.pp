# == Class: ci_environment::ufw_settings::graphite_server
#
# UFW configuration for graphite server
#
class ci_environment::firewall_config::graphite_server
{
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
