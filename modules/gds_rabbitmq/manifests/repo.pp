# == Class: gds_rabbitmq::repo
class gds_rabbitmq::repo {
  apt::source { 'rabbitmq':
    location     => 'http://apt.production.alphagov.co.uk/rabbitmq',
    release      => 'testing',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    include_src  => false,
  }

  Class['gds_rabbitmq::repo'] -> Package<| title == 'rabbitmq-server' |>
}
