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
    ]:
    ensure => installed,
  }

  package { 'brakeman':
    ensure   => 'latest',
    provider => gem,
  }
}
