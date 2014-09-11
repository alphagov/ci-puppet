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
    'aspell', 'aspell-en', 'libaspell-dev', # Needed by rummager
    'libqtwebkit-dev', # Needed by capybara-webkit (Publisher)
    'bzr', # needed by some Go builds
    'libv8-dev', # Needed by things that require V8 headers
    'vegeta', # HTTP load testing used by Router.
    'mawk-1.3.4', # Provides /opt/mawk required by pre-transition-stats
    'p7zip-full', # Provides /usr/bin/7z required by pre-transition-stats
    'libcairo2-dev', # alphagov/screenshot-as-a-service
    'libjpeg8-dev', # alphagov/screenshot-as-a-service
    'libpango1.0-dev', # alphagov/screenshot-as-a-service
    'libgif-dev', # alphagov/screenshot-as-a-service
    'cmake', # alphagov/spotlight
    'libffi-dev', # alphagov/backdrop
  ])

  class { 'goenv':
    global_version => '1.2.2',
  }
  goenv::version { ['1.2.2', '1.3.1']: }

  # FIXME remove once cleaned up everywhere.
  package { ['golang', 'golang-doc', 'golang-go', 'golang-go-linux-amd64', 'golang-src']:
    ensure => purged,
  }

  # Needed to notify github of build statuses
  package { 'ghtools':
    ensure   => '0.21.0',
    provider => pip,
    require  => Package['python-pip'],
  }

  package { 'brakeman':
    ensure   => 'latest',
    provider => gem,
  }

  class { 'ci_environment::jenkins_job_support::mysql': }
  class { 'ci_environment::jenkins_job_support::postgresql': }
  class { 'ci_environment::jenkins_job_support::rabbitmq': }
  class { 'phantomjs': }
  class { 'xvfb': } # Needed by capybara-webkit (used in Publisher)

  class { 'clamav': }

  # asset-manager relies on this symlink being present
  # pointing at clamscan not clamdscan because the clamav user doesn't
  # have read access to the workspace
  file { '/usr/local/bin/govuk_clamscan':
    ensure  => symlink,
    target  => '/usr/bin/clamscan',
    require => Class['clamav'],
  }

  # Agree to the Oracle license agreement, so that we can install Java 7, so
  # that we can install ElasticSearch
  exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
  }
  package { 'oracle-java7-installer':
    ensure  => present,
    require => [Exec['set-licence-selected'], Exec['set-licence-seen']],
  }

  apt::source { 'elasticsearch':
    location     => 'http://apt.production.alphagov.co.uk/elasticsearch-0.90',
    release      => 'stable',
    architecture => $::architecture,
    key          => '37E3ACBB',
    include_src  => false,
  }

  class { 'elasticsearch':
    version            => '0.90.12',
    number_of_replicas => '0',
    require            => Apt::Source['elasticsearch'],
  }

  class { 'redis':
    max_memory => '256mb',
  }

  # uglifier requires a JavaScript runtime
  # alphagov/spotlight requires a decent version of Node (0.10+) and grunt-cli
  package { 'nodejs':
    ensure => "0.10.29-1chl1~${::lsbdistcodename}1",
  }
  package { 'grunt-cli':
    ensure   => '0.1.9',
    provider => 'npm',
    require  => Package['nodejs'],
  }
}
