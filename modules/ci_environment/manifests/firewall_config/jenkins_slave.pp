# == Class: ci_environment::ufw_settings::jenkins_slave
#
# UFW configuration for jenkins slave
#
class ci_environment::firewall_config::jenkins_slave
{
    ufw::allow { 'allow-jenkins-slave-swarm-to-listen-on-ephemeral-ports':
        port  => '32768:65535',
        proto => 'udp',
        ip    => 'any',
    }
}
