begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# Delegate spec task task to spec:all to run all specs.
task :default => 'spec'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end
