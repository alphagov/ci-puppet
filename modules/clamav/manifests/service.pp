# == Class: clamav::service
class clamav::service {
  service { ['clamav-freshclam', 'clamav-daemon']:
    ensure  => running,
  }
}
