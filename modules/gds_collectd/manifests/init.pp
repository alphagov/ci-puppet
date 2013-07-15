# Set up collectd to write data to the management box
#   and the plugs in we want.
#
# Cribbed from https://github.com/gds-operations/monitoring-inabox
#
# The default syslog level in info, incase that gets annoying
#
class gds_collectd {
  class { '::collectd':
    purge        => true,
    recurse      => true,
    purge_config => true,
  }

  class { 'collectd::plugin::write_graphite':
    graphitehost => 'ci-management-1',
  }

  collectd::plugin {'syslog':}
  collectd::plugin {'memory':}
  collectd::plugin {'cpu':}
  collectd::plugin {'interface':}
}
