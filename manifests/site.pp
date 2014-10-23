import 'nodes'

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
