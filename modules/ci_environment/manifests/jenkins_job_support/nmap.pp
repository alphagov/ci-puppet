# == Class: ci_environment::jenkins_job_support::nmap
#
# Configures nmap, ready to be used by Jenkins jobs
#
class ci_environment::jenkins_job_support::nmap (){

  # FIXME: Remove once deployed
  package { 'nmap':
    ensure => purged,
  }
  file { '/etc/sudoers.d/jenkins-nmap':
    ensure  => absent,
    mode    => '0440',
    content => 'jenkins ALL=NOPASSWD:/usr/bin/nmap
',
  }

}
