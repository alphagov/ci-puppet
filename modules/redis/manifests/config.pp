# == Class: redis::config
class redis::config (
  $max_memory,
) {
  file { '/etc/redis/redis.conf':
    ensure  => present,
    content => template('redis/redis.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
