# == Class: xvfb
#
# Installs xvfb-server from the Ubuntu repos
class xvfb {
  anchor { 'xvfb::begin':
    notify  => Class['xvfb::service'],
  }

  class { 'xvfb::package':
    notify  => Class['xvfb::service'],
    require => Anchor['xvfb::begin'],
  }

  class { 'xvfb::service':
    require => Class['xvfb::package'],
  }

  anchor { 'xvfb::end':
    require => Class['xvfb::service'],
  }
}
