# == Class: ci_environment::jenkins_job_support::nmap
#
# Configures nmap, ready to be used by Jenkins jobs
#
class ci_environment::jenkins_job_support::nmap (){

  package { 'nmap':
    ensure => latest,
  }

  file { '/etc/sudoers.d/jenkins-nmap':
    ensure  => present,
    mode    => '0440',
    content => 'jenkins ALL=NOPASSWD:/usr/bin/nmap
',
  }

}
