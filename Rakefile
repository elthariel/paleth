require 'bundler/gem_tasks'
require 'opal/rspec/rake_task'
require 'paleth'

Opal::RSpec::RakeTask.new(:spec) do |server, _task|
  server.append_path 'vendor/assets/javascripts'
end

task default: :spec
