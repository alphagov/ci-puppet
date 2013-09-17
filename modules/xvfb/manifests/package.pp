# == Class: xvfb::package
class xvfb::package {
  package { 'xvfb':
    ensure  => present,
  }
}
