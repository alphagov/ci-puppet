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

  # Generate random cron times seeded with fqdn and username
  $hour = fqdn_rand(8, $name)
  $min  = fqdn_rand(59, $name)

  # get backup target
  $backup_target = hiera(backup_target, '/var/backups')

  duplicity{$name:
    directory => $home_dir,
    target    => $backup_target,
    hour      => $hour,
    minute    => $min,
    require   => Account[$name],
  }
}
