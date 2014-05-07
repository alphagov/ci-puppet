# == Class: gds_collectd
#
# Set up collectd to write data to the management box
#   and add the plugins we want for data collection and logging
#
# Cribbed from https://github.com/gds-operations/monitoring-inabox
#
# The default syslog level is 'info', incase that gets annoying
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
  collectd::plugin {'df':}
  collectd::plugin {'disk':}
}
