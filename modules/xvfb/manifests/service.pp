# == Class: xvfb::service
class xvfb::service {

  file { '/etc/init/xvfb.conf':
    ensure => present,
    source => 'puppet:///modules/xvfb/xvfb.conf',
  }

  service { 'xvfb':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/xvfb.conf'],
  }
}
