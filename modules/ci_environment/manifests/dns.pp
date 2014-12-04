# == Class: ci_environment::dns
#
# Sets up internal DNS on each machine
#
class ci_environment::dns {

  include dnsmasq

  $aliases = hiera('gds_dns::server::aliases', {})
  validate_hash($aliases)
  $cnames = hiera('gds_dns::server::cnames', {})
  validate_hash($cnames)
  $hosts = hiera('gds_dns::server::hosts', '')

  dnsmasq::conf { 'internal-dns':
    ensure  => present,
    content => template('ci_environment/internal-dns.erb'),
  }

  file { '/etc/hosts.dns':
    content => $hosts,
    notify  => Class['dnsmasq::service'],
  }

  $nameservers = hiera('nameservers', ['8.8.8.8', '8.8.4.4'])
  validate_array($nameservers)

  $domainname = 'internal'
  $searchpath = 'internal'
  $options = ['timeout:1']
  $use_local_resolver = true

  file { '/etc/resolvconf/resolv.conf.d/head':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ci_environment/resolv.conf.erb'),
    notify  => Class['dnsmasq::service'],
  }

}
