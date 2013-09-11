# == Class: clamav::package
class clamav::package {
  package { ['clamav', 'clamav-freshclam', 'clamav-daemon']:
    ensure  => 'latest',
  }
}
