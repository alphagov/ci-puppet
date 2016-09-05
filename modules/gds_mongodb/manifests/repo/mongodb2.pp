# Add the packagree repo for mongodb 2 packages
class gds_mongodb::repo::mongodb2 {

  if $::lsbdistcodename == 'trusty' {
    apt::source { '10gen':
      location    => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
      release     => 'dist',
      repos       => '10gen',
      key         => '492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10',
      key_server  => 'hkp://keyserver.ubuntu.com:80',
      include_src => false,
      before      => Class['mongodb'],
    }
  }

}