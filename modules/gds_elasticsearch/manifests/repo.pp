# == Class: gds_elasticsearch::repo
#
# Use our own mirror of the ES repo. Should be used with `manage_repo`
# disable of the upstream module.
#
# === Parameters
#
# [*repo_version*]
#   The Version series to add the repo for (0.90, 1.4 etc...)
#
class gds_elasticsearch::repo(
  $repo_version,
) {
  apt::source { "elasticsearch-${repo_version}":
    location     => "http://apt.production.alphagov.co.uk/elasticsearch-${repo_version}",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    include_src  => false,
  }
}
