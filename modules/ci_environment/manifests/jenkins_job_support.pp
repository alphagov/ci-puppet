# == Class: ci_environment::jenkins_job_support
#
# contains the configuration that is needed to support the jobs
#  that Jenkins runs.
#
# Add in new packages below, but be sure to comment on the job
#  that requires them
#
class ci_environment::jenkins_job_support {

  # should be used to install gems in jenkins build scripts
  package { 'bundler':
    ensure   => '1.1.4',
    provider => 'gem',
  }

  # add packages here that you require for builds to run in Jenkins
  package { [
    'python-dev', # needed for pip install C-stuff
    'python-virtualenv', # needed for infrastructure::opsmanual
    'ruby1.9.1-dev', # needed to build packages
    'libxml2-dev', # needed to install nokogiri gem
    'libxslt1-dev', # needed to install nokogiri gem
    'nodejs', # uglifier (a JS minifier) requires a JS runtime
    'build-essential', # need g++ to compile eventmachine rubygem
    'libmysqlclient-dev', # needed to install mysql2 gem
    'poppler-utils', # Required for running whitehall tests (uses pdfinfo)
    'curl', # Needed by phantomjs class to download phantomjs
    'imagemagick', # Needed by whitehall to resize images,
    'time', # Needed for timing commands during builds
    'unzip', # Needed by whitehall
    'libsqlite3-dev', # Needed by signon test suite
    'dictionaries-common', # Needed by signon
    'wbritish-small', # Needed by signon
    ]:
    ensure => installed,
  }

  # Needed to notify github of build statuses
  package { 'ghtools':
    ensure   => '0.20.0',
    provider => pip,
  }

  package { 'brakeman':
    ensure   => 'latest',
    provider => gem,
  }

  class { 'ci_environment::jenkins_job_support::mysql': }
  class { 'phantomjs': }

  class { 'clamav': }

  # asset-manager relies on this symlink being present
  # pointing at clamscan not clamdscan because the clamav user doesn't
  # have read access to the workspace
  file { '/usr/local/bin/govuk_clamscan':
    ensure  => symlink,
    target  => '/usr/bin/clamscan',
    require => Class['clamav'],
  }

  class { 'elasticsearch':
    version            => "0.20.6-ppa1~${::lsbdistcodename}1",
    number_of_replicas => '0'
  }
}
