# == Class: redis::service
class redis::service {
  service { 'redis-server':
    ensure  => running,
  }
}
