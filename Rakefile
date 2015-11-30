require 'bundler'
require 'rake'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task default: :spec

desc 'Run all specs'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

require 'quandl/utility/rake_tasks'
Quandl::Utility::Tasks.configure do |c|
  c.name              = 'quandl'
  c.version_path      = 'VERSION'
  c.changelog_path    = 'UPGRADE.md'
  c.tag_prefix        = 'v'
  c.changelog_matching  = ['^QUGC', '^WIKI']
end
