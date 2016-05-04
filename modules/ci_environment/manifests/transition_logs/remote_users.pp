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
    require  => [Ext4mount['/srv/logs/log-1'], Package['rssh']],
  }

  file {"${home_dir}/cache":
    ensure  => directory,
    owner   => 'logs_processor',
    group   => 'gds',
    mode    => '0775',
    require => Account[$name],
  }

  # Generate random cron times seeded with fqdn and username
  $hour = fqdn_rand(8, $name)
  $min  = fqdn_rand(59, $name)

  # get backup target
  # set a default of scp to localhost as the vagrant user.
  # if testing stuff you will need to generate ssh keys
  # and then add the public key to vagrant's authorized_keys.
  $backup_target = hiera('ci_environment::transition_logs::backup_target', false)

  if $backup_target {
    duplicity{$name:
      directory         => $home_dir,
      target            => "${backup_target}/${name}",
      hour              => $hour,
      minute            => $min,
      pubkey_id         => '13B84C37AB52D76B3F53CF0E7C34BD7A05119BA4',
      remove_older_than => '30D',
      require           => Account[$name],
    }
  }
}
