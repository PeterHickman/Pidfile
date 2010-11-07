# -*- ruby -*-

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

$:.push 'lib'
require 'pidfile'

PKG_NAME    = 'pidfile'
PKG_VERSION = Pid::PidFile::VERSION

spec = Gem::Specification.new do |s|
  s.name              = PKG_NAME
  s.version           = PKG_VERSION
  s.summary           = 'Use a pid file to stop multiple instances of a program being run.'

  s.files             = FileList['README', 'COPY*', 'Rakefile', 'lib/**/*.rb']
  s.test_files        = FileList['test/*.rb']

  s.has_rdoc          = true
  s.rdoc_options     << '--title' << 'PidFile' << '--charset' << 'utf-8'
  s.extra_rdoc_files  = FileList['README', 'COPYING']

  s.author            = 'Peter Hickman'
  s.email             = 'peterhi@ntlworld.com'

  s.homepage          = 'http://pidfile.rubyforge.org'
  s.rubyforge_project = 'pidfile'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

desc "Run all the tests"
Rake::TestTask.new("test") do |t|
  t.pattern = 'test/*.rb'
  t.verbose = false
  t.warning = true
end

desc 'Generate API Documentation'
Rake::RDocTask.new('rdoc') do |rdoc| 
  rdoc.rdoc_dir = 'web/doc'
  rdoc.rdoc_files.include('lib/*.rb')  
  rdoc.options << "--all"
end
