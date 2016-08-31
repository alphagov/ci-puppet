# Add the packagree repo for mongodb 3 packages
class gds_mongodb::repo::mongodb3 {

  if $::lsbdistcodename == 'trusty' {
    apt::source { 'mongodb3.2':
      location     => 'http://apt.publishing.service.gov.uk/mongodb3.2',
      release      => 'trusty-mongodb-org-3.2',
      repos        => 'multiverse',
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
      before       => Class['mongodb'],
      include_src  => false,
    }
  }

}