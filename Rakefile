# encoding: utf-8

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = %w( lib test )
  t.test_files = FileList['test/**/test_*.rb', 'test/**/*_spec.rb']
  t.ruby_opts = [ '-r./test/helper' ]
  t.verbose = true
end

task :default => :test
