# Class applied to all CI machines
class ci_environment::base {
    group { 'gds': ensure => present }
    file { '/etc/sudoers.d/gds':
        ensure  => present,
        mode    => '0440',
        content => '%gds ALL=(ALL) NOPASSWD: ALL
'
    }
    create_resources( 'account', hiera_hash('accounts'), { require => Group['gds'] } )
}
