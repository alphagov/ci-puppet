# == Class: ci_environment::ufw_settings::jenkins_master
#
# UFW configuration for jenkins master
#
class ci_environment::firewall_config::jenkins_master
{
    ufw::allow {'jenkins-slave-to-jenkins-master-on-tcp':
        port  => '39408',
        proto => 'tcp',
        ip    => 'any',
    }
    ufw::allow {'jenkins-slave-to-jenkins-master-on-udp':
        port  => '33848',
        proto => 'udp',
        ip    => 'any',
    }
    ufw::allow {'http-for-redirects-only':
        port  => '80',
        proto => 'tcp',
        ip    => 'any',
    }
    ufw::allow {'internal-http-for-jenkins':
        port  => '8080',
        proto => 'tcp',
        ip    => 'any',
    }
    ufw::allow {'https-connections':
        port  => '443',
        proto => 'tcp',
        ip    => 'any',
    }
}
