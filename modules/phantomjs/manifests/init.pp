# == Class: phantomjs
#
# Installs PhantomJS from our PPA.
class phantomjs {
  package { 'phantomjs':
    ensure => '1.9.7-0~ppa1',
  }
}
