# class to configure a replica set
class gds_mongodb($members, $replSet, $enable_mongo3_repo = false) {

  file { '/etc/mongodb':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  if $enable_mongo3_repo {
    include ::gds_mongodb::repo::mongodb3
    include ::mongodb::client             # In MongoDB 3.x the client is no longer included as part of the server install

    package { 'mongodb-org-tools':
      ensure  => present,
      require => Class['::gds_mongodb::repo::mongodb3'],
    }

  } else {
    include ::gds_mongodb::repo::mongodb2
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
