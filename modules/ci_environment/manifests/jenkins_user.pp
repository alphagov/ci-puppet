# == Class: ci_environment::jenkins_user
#
# set up the jenkins user for use accross the environment
#  this includes the .ssh dir and keys as well as git
#  config
#
class ci_environment::jenkins_user (
  $jenkins_home
) {
  validate_string($jenkins_home)

  file {'jenkins_sshdir':
    ensure  => directory,
    path    => "${jenkins_home}/.ssh",
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0700',
  }

  $private_key = "${jenkins_home}/.ssh/id_rsa"
  exec { 'Creating key pair for jenkins':
    command => "ssh-keygen -t rsa -C 'Provided by Puppet for jenkins' -N '' -f ${private_key}",
    creates => $private_key,
    user    => 'jenkins',
    require => File['jenkins_sshdir'],
  }

  file {"${jenkins_home}/.gitconfig":
    ensure  => 'present',
    owner   => 'jenkins',
    group   => 'nogroup',
    mode    => '0644',
    source  => 'puppet:///modules/ci_environment/jenkins-dot-gitconfig',
  }
}
