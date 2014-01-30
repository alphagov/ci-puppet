# == Class: ci_environment::transition_logs
#
# Class to install things only on the Transition Logs
#
class ci_environment::transition_logs {
    $accounts = hiera('ci_environment::transition_logs::rssh_users')

    ensure_packages([
        'rssh',
        # Provides /opt/mawk required by pre-transition-stats for processing logs
        'mawk-1.3.4',
    ])

    create_resources('account', $accounts, {
        shell          => '/usr/bin/rssh',
        require        => File['/srv/logs/log-1'],
        })

    file {'/etc/rssh.conf':
        ensure  => present,
        content => template('ci_environment/etc/rssh.conf.erb'),
    }

    file {['/srv/logs','/srv/logs/log-1']:
        ensure => directory,
    }

    file {'/usr/lib/rssh/rssh_chroot_helper':
        ensure => present,
        mode   => '4775',
    }

    Exec['apt-get-update'] -> Package['rssh'] -> File['/etc/rssh.conf'] -> File['/usr/lib/rssh/rssh_chroot_helper']

    class { 'rsyslog':
      log_user        => 'syslog',
      run_user        => 'syslog',
      run_group       => 'syslog',
      purge_rsyslog_d => true,
    }

    # FIXME: We don't manage the version of Puppet in the Vagrant box and
    # 3.0.2 doesn't lookup the correct boolean for `log_remote` from hiera.
    class { 'rsyslog::client':
      log_local  => true,
      log_remote => false,
    }
}
