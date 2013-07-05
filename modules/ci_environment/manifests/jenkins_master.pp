#Class to install things only on the Jenkins Master
class ci_environment::jenkins_master ($jenkins_hostname = '') {

    Package <| title == 'jenkins' |> -> Jenkins::Plugin <| |>

    package {'ssl-cert':
      ensure  => latest,
      require => Exec['apt-get-update'],
    }

    class {'nginx::server':
      require => Package['ssl-cert'],
    }

    nginx::vhost::proxy  { 'jenkins-nginx':
        ssl            => true,
        ssl_redirect   => true,
        isdefaultvhost => true,
        servername     => $jenkins_hostname
    }

    # This file resource installs a Jenkins plugin manually. The build we are
    # using is from a Pull Request and has not been merged into mainline. With
    # any luck, when version 0.14 is release, we can just use that.
    # Download URL:
    #   https://buildhive.cloudbees.com/job/jenkinsci/job/github-oauth-plugin
    #          /34/org.jenkins-ci.plugins$github-oauth/
    #
    file {'/var/lib/jenkins/plugins/github-oauth.hpi':
        ensure => 'present',
        owner  => 'jenkins',
        group  => 'nogroup',
        mode   => '0644',
        source => 'puppet:///modules/ci_environment/jenkins-plugin-github-oauth-0.14-b34.hpi',
        notify => Class['jenkins::service'],
    }
}
