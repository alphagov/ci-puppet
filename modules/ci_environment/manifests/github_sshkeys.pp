# == Class: ci_environment::github_sshkeys
#
# set up the sshkeys for github and github.gds so we don't get prompted on
#  first connections
#
class ci_environment::github_sshkeys (
  $github_dotcom_key,
  $github_dotgds_key
) {
  validate_string($github_dotcom_key, $github_dotgds_key)

  sshkey { 'github.com':
    ensure => present,
    type   => 'ssh-rsa',
    key    => $github_dotcom_key,
  }

  sshkey { 'github.gds':
    ensure => present,
    type   => 'ssh-rsa',
    key    => $github_dotgds_key,
  }
}
