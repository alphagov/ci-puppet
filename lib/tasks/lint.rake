require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint.configuration.fail_on_warnings = true
