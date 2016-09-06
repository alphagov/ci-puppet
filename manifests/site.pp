# Use hiera as a lightweight ENC (external node classifier).
$machine_role = regsubst($::clientcert, '^(.*)-[^\.]+\..*$', '\1')
$machine_id = regsubst($::clientcert, '^.*-([^\.]+)\..*$', '\1')

node default {
  if $::lsbdistcodename == 'precise' {
    # on precise the libaugeas-ruby package is an alias for libaugeas-ruby1.8
    # which will pull in ruby1.8 as the default system ruby interpreter.  This
    # breaks many things.
    $ruby_augeas_package = 'libaugeas-ruby1.9.1'
  } else {
    $ruby_augeas_package = 'libaugeas-ruby'
  }
  ensure_packages([$ruby_augeas_package])
  Package[$ruby_augeas_package] -> Augeas <| |>

  hiera_include('classes')
}

Exec {
  path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

# Ensure update is always run before any package installs.
# title conditions prevent a dependency loop within apt module.
Class['apt::update'] -> Package <|
  provider != pip and
  provider != gem and
  provider != system_gem and
  ensure != absent and
  ensure != purged and
  title != 'python-software-properties' and
  title != 'software-properties-common' and
  tag != 'no_require_apt_update'
|>
