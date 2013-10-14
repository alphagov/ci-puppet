# == Class: ci_environment::jenkins_job_support::mysql
# Installs mysql on the server
class ci_environment::jenkins_job_support::mysql {
  class { '::mysql': }
  class { '::mysql::server':
    require     => Class['::mysql']
  }

  mysql::server::config { 'innodb':
    settings => {
      'mysqld' => {
        'innodb_flush_log_at_trx_commit'     => '0',
      },
    }
  }

  mysql::db {
    'contacts_test':
      user     => 'contacts',
      password => 'contacts',
      require  => Class['::mysql::server'];

    [
      'datainsights_todays_activity_test',
      'datainsight_weekly_reach_test',
      'datainsights_format_success_test',
      'datainsight_insidegov_test',
    ]:
      user     => 'datainsight',
      password => 'datainsight',
      require  => Class['::mysql::server'];

    [
      'efg_test',
      'efg_test1',
      'efg_test2',
      'efg_test3',
      'efg_test4',
    ]:
      user     => 'efg',
      password => 'efg',
      require  => Class['::mysql::server'];

    'panopticon_test':
      user     => 'panopticon',
      password => 'panopticon',
      require  => Class['::mysql::server'];

    ['release_development', 'release_test']:
      user     => 'release',
      password => 'release',
      require  => Class['::mysql::server'];

    ['signonotron2_test', 'signonotron2_integration_test']:
      user     => 'signonotron2',
      password => 'signonotron2',
      require  => Class['::mysql::server'];

    'tariff_admin_test':
      user     => 'tariff_admin',
      password => 'tariff_admin',
      require  => Class['::mysql::server'];

    'tariff_test':
      user     => 'tariff',
      password => 'tariff',
      require  => Class['::mysql::server'];

    'transition_test':
      user     => 'transition',
      password => 'transition',
      require  => Class['::mysql::server'];

    [
      'whitehall_development',
      'whitehall_test',
      'whitehall_test1',
      'whitehall_test2',
      'whitehall_test3',
      'whitehall_test4',
      'whitehall_test5',
      'whitehall_test6',
      'whitehall_test7',
      'whitehall_test8',
      'whitehall_test9',
      'whitehall_test10',
      'whitehall_test11',
      'whitehall_test12',
      'whitehall_test13',
      'whitehall_test14',
      'whitehall_test15',
      'whitehall_test16'
    ]:
      user     => 'whitehall',
      password => 'whitehall',
      grant    => ['ALL'],
      require  => Class['::mysql::server'];
  }
}
