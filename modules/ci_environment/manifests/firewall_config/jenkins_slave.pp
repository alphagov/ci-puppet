# == Class: ci_environment::ufw_settings::jenkins_slave
#
# firewall configuration for jenkins slave
#
# The jenkins slave swarm sends a upd broadcast message to find a master
#   and then listens on an ephemeral port for a response
# It then connects to the master and uses standard jenkins slave
#   behaviours to connect to the master as a slave
#
class ci_environment::firewall_config::jenkins_slave
{
  ufw::allow { 'allow-jenkins-slave-swarm-to-listen-on-ephemeral-ports':
    port  => '32768:65535',
    proto => 'udp',
    ip    => 'any',
  }
  ufw::allow { 'allow-cdn-acceptance-tests-8080-8090':
    port  => '8080:8090',
    proto => 'tcp',
    ip    =? 'any'
  }
}
