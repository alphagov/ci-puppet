# == Class: ci_environment::ufw_settings::jenkins_master
#
# firewall configuration for jenkins master
#
# The plug in for the slave swarm
#  - listens for UDP broadcasts on 33848
#  - sends the slave the jenkins url so the client can connect as a slave
#
# The JNLP slave agent listener started on a ephemeral TCP port listening
#  for slave connections
#
class ci_environment::firewall_config::jenkins_master
{
  ufw::allow {'jenkins-slave-to-jenkins-master-on-tcp':
    port  => '32768:65535',
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
  ufw::allow {'internal-http-for-jenkins-and-slaves':
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
