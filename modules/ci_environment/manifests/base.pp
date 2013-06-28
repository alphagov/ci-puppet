# Class applied to all CI machines
class ci_environment::base {
    group { 'gds': ensure => present }
    file { '/etc/sudoers.d/gds':
        ensure  => present,
        mode    => '0440',
        content => '%gds ALL=(ALL) NOPASSWD: ALL
'
    }
    $account_defaults = { require => Group['gds'] }
    create_resources( 'account', hiera_hash('accounts'), $account_defaults )

    exec { 'apt-get-update':
        command => '/usr/bin/apt-get update || true',
    }
}
