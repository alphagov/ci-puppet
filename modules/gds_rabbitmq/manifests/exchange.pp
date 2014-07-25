# == Define: gds_rabbitmq::exchange
#
# Manage a rabbitmq exchange.  This is just a wrapper around
# the rabbitmq module's defined type that adds the 'root' user
# creds.
#
define gds_rabbitmq::exchange (
  $type,
  $ensure = present,
) {

  rabbitmq_exchange { $name:
    ensure   => $ensure,
    user     => 'root',
    password => $::gds_rabbitmq::root_password,
    type     => $type,
  }
}
