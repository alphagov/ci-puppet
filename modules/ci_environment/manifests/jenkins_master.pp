#Class to install things only on the Jenkins Master
class ci_environment::jenkins_master (
    $ssh_private_key = undef,
) {
    if ($ssh_private_key) {
        # Install the SSH private key for Jenkins
        file { '/home/jenkins':
            ensure  => directory,
            mode    => '0700',
            owner   => 'jenkins',
            group   => 'jenkins',
            require => Class['jenkins'],
        }
        file { '/home/jenkins/.ssh':
            ensure  => directory,
            mode    => '0700',
            owner   => 'jenkins',
            group   => 'jenkins',
            require => File['/home/jenkins'],
        }
        file { '/home/jenkins/.ssh/id_rsa':
            ensure  => present,
            content => $ssh_private_key,
            mode    => '0600',
            owner   => 'jenkins',
            group   => 'jenkins',
            require => File['/home/jenkins/.ssh'],
        }
    }
}
