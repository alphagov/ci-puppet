# == Class: gds_mongodb
#
# class to configure a replica set
#
# === Parameters
# [*members*]
#   Individual hosts in a replicaset. Defined as an array.
#
# [*replSet*]
#   Name of the replicaset.
#
# [*service*]
#   MongoDB-Server daemon name.
#
class gds_mongodb(
  $members,
  $replSet,
  $service
) {
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
      Service[$service],
    ],
  }
}
