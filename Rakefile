require "rubygems"
require "bundler"
Bundler.setup

require 'rake/testtask'

task default: 'test'

Rake::TestTask.new(:test) do |t|
  t.libs << '.' << 'lib' << 'test'
  t.test_files = FileList['test/sliding_puzzle/**/*_test.rb']
  t.verbose = false
end
