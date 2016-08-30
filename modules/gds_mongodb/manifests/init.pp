# class to configure a replica set
class gds_mongodb($members, $replset) {
  file { '/etc/mongodb':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/mongodb/configure-replica-set.js':
    ensure  => present,
    content => template('gds_mongodb/configure-replica-set.js'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['mongodb'],
  }

  exec { 'configure-replica-set':
    command => "/usr/bin/mongo --host ${members[0]} /etc/mongodb/configure-replica-set.js",
    unless  => "/usr/bin/mongo --host ${members[0]} --quiet --eval 'rs.status().ok' | grep -q 1",
    require => [
      File['/etc/mongodb/configure-replica-set.js'],
      Service['mongodb'],
    ],
  }
}
