# == Class: ci_environment::jenkins_slave
#
# Class to install things only on the Jenkins Slave
#
# API token in hiera needs to be updated after provisioning a new master.
#
class ci_environment::jenkins_slave (
  $jenkins_home,
  $labels = []
) {
  validate_array($labels)

  include java

  $labels_with_distribution = concat($labels, [downcase("${::lsbdistid}-${::lsbdistcodename}")])
  class { 'jenkins::slave':
    labels => sprintf('\'%s\'', join($labels_with_distribution, ' ')),
  }

  include jenkins_job_support

  class {'github_gds_cert':
    jenkins_home => $jenkins_home,
  }

  class {'jenkins_user':
    jenkins_home => $jenkins_home,
  }

  Class['java'] -> Class['jenkins::slave'] -> Class['jenkins_user']
}
