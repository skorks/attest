require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "attest"
    gem.summary = %Q{An inline unit testing/spec framework that doesn't force you to follow arbitrary rules}
    gem.description = %Q{Attest allows you to define spec-like tests inline (within the same file as your actual code) which means almost non-existant overheads to putting some tests around your code. It also tries to not be too prescriptive regarding the 'right' way to test. You want to test private methods - go ahead, access unexposed instance variables - no worries, pending and disabled tests are first class citizens. Don't like the output format, use a different one or write your own. Infact you don't even have to define you tests inline if you prefer the 'traditional' way, separate directory and all. You should be allowed to test your code the way you want to, not the way someone else says you have to!}
    gem.email = "alan@skorks.com"
    gem.homepage = "http://github.com/skorks/attest"
    gem.authors = ["Alan Skorkin"]
    #gem.add_runtime_dependency "bundler"
    #gem.add_runtime_dependency "mocha"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "attest #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
