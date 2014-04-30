# class to generate remote log upload users.
define ci_environment::transition_logs::remote_users (
  $comment,
  $ssh_key,
  $home_dir
){

  account{$name:
    comment  => $comment,
    ssh_key  => $ssh_key,
    home_dir => $home_dir,
    shell    => '/usr/bin/rssh',
    require  => File['/srv/logs/log-1'],
  }

}
