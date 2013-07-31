# == Class: ci_environment::jenkins_git_config
#
# set up git for use for the Jenkins user
#
class ci_environment::jenkins_git_config {
    file {'/var/lib/jenkins/.gitconfig':
        ensure => 'present',
        owner  => 'jenkins',
        group  => 'nogroup',
        mode   => '0644',
        source => 'puppet:///modules/ci_environment/jenkins-dot-gitconfig',
    }
}
