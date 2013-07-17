# Class applied to all CI machines
class ci_environment::base(
  $accounts
) {
    validate_hash($accounts)

    include harden

    group { 'gds': ensure => present }
    file { '/etc/sudoers.d/gds':
        ensure  => present,
        mode    => '0440',
        content => '%gds ALL=(ALL) NOPASSWD: ALL
'
    }
    $account_defaults = {
                        require      => Group['gds'],
                        create_group => false,
                        groups       => ['gds']
                        }
    create_resources('account', $accounts, $account_defaults )

    exec { 'apt-get-update':
        command => '/usr/bin/apt-get update || true',
    }
    Exec <| title == 'apt-get-update' |> -> Package <| provider == 'apt' |>
}
