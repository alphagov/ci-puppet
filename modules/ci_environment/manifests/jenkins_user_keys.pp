# == Class: ci_environment::jenkins_user_keys
#
# set up jenkins user's keys for access to git
#
class ci_environment::jenkins_user_keys {
  $jenkins_home = '/var/lib/jenkins'
  $private_key = "${jenkins_home}/.ssh/id_rsa"
  $public_key = "${jenkins_home}/.ssh/id_rsa.pub"

  file { $public_key:
    checksum => md5,
    require  => [ User['jenkins'], File["${jenkins_home}/.ssh"] ],
  }

  file { "${jenkins_home}/.ssh":
    ensure => directory,
    mode   => '0600',
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  exec { 'Creating key pair for jenkins':
    command => "ssh-keygen -t rsa -C 'Provided by Puppet for jenkins' -N '' -f ${private_key}",
    creates => $private_key,
    require => [
      User['jenkins'],
      File["${jenkins_home}/.ssh"]
    ],
    user    => 'jenkins',
  }
}
