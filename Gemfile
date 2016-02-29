source 'https://rubygems.org'

# Versions can be overridden with environment variables for matrix testing.
# Travis will remove Gemfile.lock before installing deps. As such, it is
# advisable to pin major versions in this Gemfile.

# Puppet core.
gem 'puppet', ENV['PUPPET_VERSION'] || '= 3.7.1'
gem 'facter', ENV['FACTER_VERSION'] || '= 2.2.0'

# Dependency management.
gem "librarian-puppet", '~> 2.0'

# Testing utilities.
gem 'rake'
gem 'puppet-syntax'
gem 'puppet-lint', :github => 'rodjek/puppet-lint', :ref => '2546fe'
gem 'puppet-lint-trailing_comma-check', :require => false
gem 'rspec-puppet', '~> 0.1.0'
gem 'puppetlabs_spec_helper', '~> 0.4.0'
gem 'hiera-puppet-helper', :git => 'git://github.com/bobtfish/hiera-puppet-helper.git'
gem "parallel_tests", "~> 0.16.10"
gem "parallel", "~> 1.0.0"
