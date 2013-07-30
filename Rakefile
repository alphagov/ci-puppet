require 'rspec/core/rake_task'
require 'puppet'


# Ignore vendored code. Called by other tasks.
def exclude_paths
  ["vendor/**/*"]
end

# Break tasks out to individual rake files to prevent clutter.
FileList['lib/tasks/*.rake'].each do |rake_file|
  import rake_file
end

def get_modules
  if ENV['mods']
    ENV['mods'].split(',').map { |x| x == 'manifests' ? x : "modules/#{x}" }
  else
    ['manifests', 'modules/*']
  end
end

desc "Run all tests"
task :test => [:spec]

task :default => [
  :syntax,
  :lint,
  :test
]
