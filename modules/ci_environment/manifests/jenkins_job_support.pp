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
    'python-virtualenv', # needed for infrastructure::opsmanual
    'ruby1.9.1-dev', # needed to build packages
    'libxml2-dev', # needed to install nokogiri gem
    'libxslt1-dev', # needed to install nokogiri gem
    'nodejs', # uglifier (a JS minifier) requires a JS runtime
    'build-essential', # need g++ to compile eventmachine rubygem
    'libmysqlclient-dev', # needed to install mysql2 gem
    'poppler-utils', # Required for running whitehall tests (uses pdfinfo)
    'curl', # Needed by phantomjs class to download phantomjs
    'imagemagick', # Needed by whitehall to resize images
    ]:
    ensure => installed,
  }

  package { 'brakeman':
    ensure   => 'latest',
    provider => gem,
  }

  class { 'ci_environment::jenkins_job_support::mysql': }
  class { 'phantomjs': }
}
