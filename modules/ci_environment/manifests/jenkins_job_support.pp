# == Class: ci_environment::jenkins_job_support
#
# contains the configuration that is needed to support the jobs
#  that Jenkins runs.
#
# Add in new packages below, but be sure to comment on the job
#  that requires them
#
class ci_environment::jenkins_job_support {
  # redirector's tests require some Perl packages (see below)
  include cpanm::install

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
    'nodejs', # uglifier (a JS minifier) requires a JS runtime
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
  ])

  # Needed to notify github of build statuses
  package { 'ghtools':
    ensure   => '0.21.0',
    provider => pip,
  }

  package { 'brakeman':
    ensure   => 'latest',
    provider => gem,
  }

  class { 'ci_environment::jenkins_job_support::mysql': }
  class { 'phantomjs': }
  class { 'xvfb': } # Needed by capybara-webkit (used in Publisher)

  # redirector's tests require these Perl packages
  package { [
    'Text::CSV',
    'YAML',
    'Crypt::SSLeay',
    'Mozilla::CA'
  ]:
    ensure   => present,
    provider => 'cpanm',
  }

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

  class { 'elasticsearch':
    version            => "0.20.6-ppa1~${::lsbdistcodename}1",
    number_of_replicas => '0'
  }

  class { 'redis':
    max_memory => '256mb',
  }
}
