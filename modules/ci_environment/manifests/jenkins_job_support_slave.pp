# == Class: ci_environment::jenkins_job_support_slave
#
# job_support contains the configuration that is needed to support the jobs
# that Jenkins runs. However, these should only do job scheduling and so
# has been split into a slave pp
#
class ci_environment::jenkins_job_support_slave {

  class { 'clamav': }
  # asset-manager relies on this symlink being present
  # pointing at clamscan not clamdscan because the clamav user doesn't
  # have read access to the workspace
  file { '/usr/local/bin/govuk_clamscan':
    ensure  => symlink,
    target  => '/usr/bin/clamscan',
    require => Class['clamav'],
  }

  class { 'elasticsearch':
    version            => "0.20.6-ppa1~${::lsbdistcodename}1",
    number_of_replicas => '0'
  }

  class { 'redis':
    max_memory => '256mb',
  }

}
