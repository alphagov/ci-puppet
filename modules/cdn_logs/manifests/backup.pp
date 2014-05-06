#class to backup cdn logs.
class cdn_logs::backup (
  $log_dir = '/srv/logs/log-1/cdn',
  $backup_target = false,
){

if $backup_target {
    duplicity{'cdn':
      directory => $log_dir,
      target    => "${backup_target}/cdn",
      hour      => 22,
      minute    => 10,
      pubkey_id => '13B84C37AB52D76B3F53CF0E7C34BD7A05119BA4',
      require   => File[$log_dir],
    }
  }
}
