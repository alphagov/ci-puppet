# == Class: ci_environment::transition_logs
#
# Class to install things only on the Transition Logs
#
class ci_environment::transition_logs {
    $logs_processor_home = '/srv/logs/log-1/logs_processor'

    account {
        'logs_processor':
            home_dir => $logs_processor_home,
            groups   => [ 'syslog', 'adm' ],
            comment  => 'A user to process logs from Fastly and agencies and push into a GitHub repo',
            require  => Ext4mount['/srv/logs/log-1'],
    }

    $transition_stats_key = "${logs_processor_home}/.ssh/transition_stats_deploy_key_rsa"
    exec { 'Creating transition-stats deploy key pair for logs_processor':
        command => "ssh-keygen -t rsa -C 'Provided by Puppet for logs_processor' -N '' -f ${transition_stats_key}",
        creates => $transition_stats_key,
        user    => 'logs_processor',
        require => Account['logs_processor'],
    }

    $pre_transition_stats_key = "${logs_processor_home}/.ssh/pre_transition_stats_deploy_key_rsa"
    exec { 'Creating pre-transition-stats deploy key pair for logs_processor':
        command => "ssh-keygen -t rsa -C 'Provided by Puppet for logs_processor' -N '' -f ${pre_transition_stats_key}",
        creates => $pre_transition_stats_key,
        user    => 'logs_processor',
        require => Account['logs_processor'],
    }

    file {"${logs_processor_home}/.gitconfig":
        ensure  => 'present',
        owner   => 'logs_processor',
        group   => 'logs_processor',
        mode    => '0644',
        source  => 'puppet:///modules/ci_environment/logs_processor-dot-gitconfig',
        require => Account['logs_processor'],
    }

    file {"${logs_processor_home}/.ssh/config":
        ensure  => 'present',
        owner   => 'logs_processor',
        group   => 'logs_processor',
        mode    => '0644',
        source  => 'puppet:///modules/ci_environment/logs_processor_ssh_config',
        require => Account['logs_processor'],
    }

    file {"${logs_processor_home}/process_transition_logs.sh":
        ensure  => 'present',
        owner   => 'logs_processor',
        group   => 'logs_processor',
        mode    => '0744',
        source  => 'puppet:///modules/ci_environment/process_transition_logs.sh',
        require => Account['logs_processor'],
    }

    cron { 'process_fastly_logs':
        ensure      => present,
        environment => 'PATH=/usr/lib/rbenv/shims:/usr/sbin:/usr/bin:/sbin:/bin',
        command     => "${logs_processor_home}/process_transition_logs.sh",
        user        => logs_processor,
        target      => logs_processor,
        hour        => absent,
        minute      => 30,
        require     => File["${logs_processor_home}/process_transition_logs.sh"]
    }

    cron { 'restart_rsyslog':
        ensure      => present,
        environment => 'PATH=/usr/sbin:/usr/bin:/sbin:/bin',
        command     => 'service rsyslog restart',
        user        => root,
        hour        => absent,
        minute      => 5
    }

    ensure_packages([
        # Provides /opt/mawk required by pre-transition-stats for processing logs
        'mawk-1.3.4',
        # We need to decompress some 7zipped agency logs
        'p7zip-full',
        'python-paramiko',
        'python-gobject-2'
    ])

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
