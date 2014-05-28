# == Class: phantomjs
#
# Installs phantomjs, by downloading from our s3 bucket.
class phantomjs {
  package { 'phantomjs':
    ensure => '1.9.7-0~ppa1',
  }

  # FIXME: remove when this has been run everywhere
  file { '/usr/local/bin/phantomjs':
    ensure  => absent,
  }
}
