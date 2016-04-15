# class ci_environment::transition_logs::s3_backups
#
# [*directory*]
#   Defines the directory to backup
#
# [*hour*]
#   Defines the hour to run the cron job
#
# [*minute*]
#   Defines the minute to run the cron job
#
# [*retention*]
#   Defines the number of full backups to retain
#
# [*s3_bucket*]
#   Defines the AWS S3 bucket destination for backups
#
# [*s3_aws_id*]
#   Defines the AWS access id with permission to write to 
#   the S3 bucket
#
# [*s3_aws_key*]
#   Defines the AWS access secret key for the defined aws access id

class ci_environment::transition_logs::s3_backups(
  $directory = '/srv/logs/log-1',
  $hour = 4,
  $minute = 15,
  $retention = 30,
  $s3_bucket = undef,
  $s3_aws_id = undef,
  $s3_aws_key = undef,
  ){

  duplicity { 'transition-logs-s3-backups':
    directory             => $directory,
    bucket                => $s3_bucket,
    dest_id               => $s3_aws_id,
    dest_key              => $s3_aws_key,
    pubkey_id             => '13B84C37AB52D76B3F53CF0E7C34BD7A05119BA4',
    hour                  => $hour,
    minute                => $minute,
    remove_all_but_n_full => $retention,
  }

}
