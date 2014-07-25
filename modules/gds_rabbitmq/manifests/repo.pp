# == Class: gds_rabbitmq::repo
class gds_rabbitmq::repo {
  apt::source { 'rabbitmq':
    location     => 'http://apt.production.alphagov.co.uk/rabbitmq',
    release      => 'testing',
    architecture => $::architecture,
    key          => '37E3ACBB',
    include_src  => false,
  }

  Class['gds_rabbitmq::repo'] -> Package<| title == 'rabbitmq-server' |>
}
