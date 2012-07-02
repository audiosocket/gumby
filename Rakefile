require "bundler/gem_tasks"

desc "Run the tests."
task(:test) { $: << "./lib"; Dir["test/*_test.rb"].each { |f| load f } }

task :default => :test
