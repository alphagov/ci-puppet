# == Class: transition_logs
#
# Class to install things only on the Transition Logs
#
class transition_logs(
  $accounts,
) {
    package{'rssh':
        ensure => present,
    }

    create_resources('account', $accounts, {
        shell          => '/usr/bin/rssh',
        require        => File['/srv/logs/log-1'],
        })

    file {'/etc/rssh.conf':
        ensure  => present,
        content => template('transition_logs/etc/rssh.conf.erb'),
    }

    file {['/srv/logs','/srv/logs/log-1']:
        ensure => directory,
    }

    file {'/usr/lib/rssh/rssh_chroot_helper':
        ensure => present,
        mode   => '4775',
    }

    Exec['apt-get-update'] -> Package['rssh'] -> File['/etc/rssh.conf'] -> File['/usr/lib/rssh/rssh_chroot_helper']
}
