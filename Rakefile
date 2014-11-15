require 'foodcritic'
require 'kitchen'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

namespace :style do
  FoodCritic::Rake::LintTask.new(:chef)
  RuboCop::RakeTask.new(:ruby)
end

namespace :kitchen do
  task :vagrant do
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

task style: ['style:chef', 'style:ruby']

RSpec::Core::RakeTask.new(:spec)

task default: %w(style spec)
