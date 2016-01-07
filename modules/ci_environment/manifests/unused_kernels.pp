# Class: ci_environment::unused_kernels
#
# Periodically remove packages for Ubuntu kernels that are no longer used in
# order to reclaim disk space (inodes).
#
class ci_environment::unused_kernels {
  package { 'ubuntu_unused_kernels':
    ensure   => '0.2.0',
    provider => 'gem',
  } ->
  file { '/etc/cron.daily/remove_unused_kernels':
    ensure => present,
    source => 'puppet:///modules/ci_environment/etc/cron.daily/remove_unused_kernels',
    mode   => '0755',
  }
}
