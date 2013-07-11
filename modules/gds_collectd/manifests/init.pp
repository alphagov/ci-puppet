# including collectd
class gds_collectd {
  include collectd
  include collectd::plugin::write_graphite
  collectd::plugin {'cpu':}
}
