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
# [*pubkey_id*]
#   The public gpg key fingerprint to a key that 
#   has been uploaded to keyserver.ubuntu.com.
#   This module uses only the public key for encryption.
#
#   A keypair should have been generated locally on 
#   the user's machine and the private key stored safely
#   offline. Backup files can be decrypted with this private
#   key, though it is outside the scope of this module.
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
  $retention = 4,
  $s3_bucket = undef,
  $s3_aws_id = undef,
  $s3_aws_key = undef,
  ){

  duplicity { 'transition-logs-s3-backups':
    directory             => $directory,
    bucket                => $s3_bucket,
    dest_id               => $s3_aws_id,
    dest_key              => $s3_aws_key,
    pubkey_id             => '05793B692E9C76BAAE19FB9FA95451F692B59227',
    hour                  => $hour,
    minute                => $minute,
    remove_all_but_n_full => $retention,
  }

}
