# == Class: ci_environment::github_gds_cert
#
# installed the public cert needed for talking to the api on github.gds
#
class ci_environment::github_gds_cert (
  $jenkins_home,
) {

  File {
    owner => jenkins,
    group => jenkins,
  }

  file {
    "${jenkins_home}/govuk":
      ensure  => directory;
    "${jenkins_home}/govuk/cert":
      ensure  => directory;
    "${jenkins_home}/govuk/cert/github.gds.pem":
      ensure  => present,
      source  => 'puppet:///modules/ci_environment/github.gds.pem';
  }
}
