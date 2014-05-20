#class to set up disks on transition-logs-1
class ci_environment::transition_logs::disks {

  physical_volume { '/dev/sdc1':
    ensure => present,
  }

  physical_volume { '/dev/sdb1':
    ensure => present,
  }

  volume_group { 'logs':
    ensure           => present,
    physical_volumes => ['/dev/sdc1', '/dev/sdb1'],
  }

  logical_volume { 'remote_users':
    ensure       => present,
    volume_group => 'logs',
    size         => '512G',
  }

  filesystem { '/dev/logs/remote_users':
    ensure  => present,
    fs_type => 'ext4',
    require => Logical_volume['remote_users'],
  }

  ext4mount { '/srv/logs/log-1':
    disk         => '/dev/mapper/logs-remote_users',
    mountoptions => 'defaults',
    mountpoint   => '/srv/logs/log-1',
    require      => Filesystem['/dev/logs/remote_users'],
  }

  logical_volume { 'cdn':
    ensure       => present,
    volume_group => 'logs',
    extents      => '32767',
  }

  filesystem { '/dev/logs/cdn':
    ensure  => present,
    fs_type => 'ext4',
  }
  ext4mount { '/srv/logs/log-1/cdn':
    disk         => '/dev/mapper/logs-cdn',
    mountoptions => 'defaults',
    mountpoint   => '/srv/logs/log-1/cdn',
    require      => [Filesystem['/dev/logs/cdn'],Ext4mount['/srv/logs/log-1']],
  }


}
