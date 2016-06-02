# == Class: gds_elasticsearch::estools
#
# Install the estools package (which we maintain, see
# https://github.com/alphagov/estools).
class gds_elasticsearch::estools {
  package { 'estools':
    ensure   => '1.1.1',
    provider => 'pip',
    require  => Package['python-pip'],
  }
}
