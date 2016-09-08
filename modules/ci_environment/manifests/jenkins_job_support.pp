# == Class: ci_environment::jenkins_job_support
#
# contains the configuration that is needed to support the jobs
#  that Jenkins runs.
#
# Add in new packages below, but be sure to comment on the job
#  that requires them
#
class ci_environment::jenkins_job_support {

  # add packages here that you require for builds to run in Jenkins
  ensure_packages([
    'python-dev', # needed for pip install C-stuff
    'python-virtualenv', # needed for infrastructure::opsmanual
    'ruby1.9.1-dev', # needed to build packages
    'build-essential', # need g++ to compile eventmachine rubygem
    'libmysqlclient-dev', # needed to install mysql2 gem
    'poppler-utils', # Required for running whitehall tests (uses pdfinfo)
    'curl', # Needed by phantomjs class to download phantomjs
    'imagemagick', # Needed by whitehall to resize images,
    'time', # Needed for timing commands during builds
    'dictionaries-common', # Needed by signon
    'wbritish-small', # Needed by signon
    'sqlite3', # Needed by gds-sso
    'libqtwebkit-dev', # Needed by capybara-webkit (Publisher)
    'bzr', # needed by some Go builds
    'mercurial', # needed by some Go builds
    'mawk-1.3.4', # Provides /opt/mawk required by pre-transition-stats
    'p7zip-full', # Provides /usr/bin/7z required by pre-transition-stats
    'libcairo2-dev', # alphagov/screenshot-as-a-service
    'libjpeg8-dev', # alphagov/screenshot-as-a-service
    'libpango1.0-dev', # alphagov/screenshot-as-a-service
    'libgif-dev', # alphagov/screenshot-as-a-service
    'cmake', # alphagov/spotlight
    'libffi-dev', # alphagov/backdrop
    'binutils', # alphagov/mapit
    'libproj-dev', # alphagov/mapit
    'gdal-bin', # alphagov/mapit
    'libgdal-dev', # alphagov/mapit
  ])

  # libv8 development headers.  Needed by some gems (eg therubyracer)
  if $::lsbdistcodename == 'precise' {
    ensure_packages(['libv8-dev'])
  } else {
    # On trusty, npm indirectly depends on libv8-3.14-dev which conflicts with
    # libv8-dev (even though they're both 3.14)
    ensure_packages(['libv8-3.14-dev'])
  }

  class { 'goenv':
    global_version => '1.7.1',
  }
  goenv::version { ['1.6.3', '1.7', '1.7.1']: }

  goenv::version { ['1.3.3', '1.4.2', '1.4.3', '1.5.1', '1.5.3', '1.6.2']:
    ensure => absent,
  }

  package { ['golang-gom', 'godep']:
    ensure => latest,
  }

  # Needed to notify github of build statuses
  ensure_packages(['python-pip'])
  package { 'ghtools':
    ensure   => '0.23.0',
    provider => pip,
    require  => Package['python-pip'],
  }

  package { 'brakeman':
    ensure   => 'latest',
    provider => gem,
  }

  include ci_environment::jenkins_job_support::mysql
  include ci_environment::jenkins_job_support::postgresql
  include ci_environment::jenkins_job_support::rabbitmq
  include ci_environment::jenkins_job_support::nmap
  include phantomjs
  include xvfb # Needed by capybara-webkit (used in Publisher)

  include clamav

  # asset-manager relies on this symlink being present
  # pointing at clamscan not clamdscan because the clamav user doesn't
  # have read access to the workspace
  file { '/usr/local/bin/govuk_clamscan':
    ensure  => symlink,
    target  => '/usr/bin/clamscan',
    require => Class['clamav'],
  }

  # Functions to handle the Oracle license agreement, so that we can install Java unattended
  exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
  }
  # Install Java 8 for Licensify and Elasticsearch
  package { 'oracle-java8-installer':
    ensure  => present,
    require => [Exec['set-licence-selected'], Exec['set-licence-seen']],
  }

  # FIXME: remove once this has run everywhere.
  package { [
      'openjdk-6-jdk',
      'openjsk-6-jre',
      'openjdk-6-jre-headless',
      'openjdk-6-jre-lib',
      'oracle-java7-installer',
    ]:
      ensure => purged;
  }

  include gds_elasticsearch

  class { 'redis':
    max_memory => '256mb',
  }

  # uglifier requires a JavaScript runtime
  # alphagov/spotlight requires a decent version of Node (0.10+) and grunt-cli
  package { 'nodejs':
    ensure => 'latest',
  }
  package { 'grunt-cli':
    ensure   => '0.1.9',
    provider => 'npm',
    require  => Package['nodejs'],
  }
}
