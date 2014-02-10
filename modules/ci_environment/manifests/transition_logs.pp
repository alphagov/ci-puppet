# == Class: ci_environment::transition_logs
#
# Class to install things only on the Transition Logs
#
class ci_environment::transition_logs {
    $logs_processor_home = '/srv/logs/log-1/logs_processor'

    create_resources(
        'account',
        {
            'logs_processor':
                home_dir => $logs_processor_home,
                groups   => [ 'root', 'adm' ],
                comment  => 'A user to process logs from Fastly and agencies and push into a GitHub repo',
        },
        { require => File['/srv/logs/log-1'] }
    )

    file {'logs_processor_sshdir':
        ensure  => directory,
        path    => "${logs_processor_home}/.ssh",
        owner   => 'logs_processor',
        group   => 'logs_processor',
        mode    => '0700',
    }

    $private_key = "${logs_processor_home}/.ssh/id_rsa"
    exec { 'Creating key pair for logs_processor':
        command => "ssh-keygen -t rsa -C 'Provided by Puppet for logs_processor' -N '' -f ${private_key}",
        creates => $private_key,
        user    => 'logs_processor',
        require => File['logs_processor_sshdir'],
    }

    file {"${logs_processor_home}/.gitconfig":
        ensure  => 'present',
        owner   => 'logs_processor',
        group   => 'logs_processor',
        mode    => '0644',
        source  => 'puppet:///modules/ci_environment/logs_processor-dot-gitconfig',
    }

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
