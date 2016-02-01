# == Class: ci_environment::firewall_config::base
#
# base firewall config for all machines
#
class ci_environment::firewall_config::base
{
  include ufw
  ufw::allow { 'allow-ssh-from-all':
    port => '22',
    ip   => 'any',
  }
}
