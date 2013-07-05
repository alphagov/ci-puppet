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
}
