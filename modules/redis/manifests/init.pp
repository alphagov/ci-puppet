# == Class: redis
#
# Installs redis-server from the Ubuntu repos
class redis (
  $max_memory = undef,
) {
  anchor { 'redis::begin':
    notify  => Class['redis::service'],
  }

  class { 'redis::package':
    notify  => Class['redis::config'],
    require => Anchor['redis::begin'],
  }

  class { 'redis::config':
    notify     => Class['redis::service'],
    require    => Class['redis::package'],
    max_memory => $max_memory,
  }

  class { 'redis::service':
    require => Class['redis::config'],
  }

  anchor { 'redis::end':
    require => Class['redis::service'],
  }
}
