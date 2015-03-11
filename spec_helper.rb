require 'csv'
require 'rspec-puppet'
require 'puppet'

HERE = File.expand_path(File.dirname(__FILE__))

RSpec.configure do |c|
  c.manifest    = File.join(HERE, 'manifests', 'site.pp')
  c.module_path = [
    File.join(HERE, 'modules'),
    File.join(HERE, 'vendor', 'modules')
  ].join(':')
end
