require 'rubygems'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

PKG_FILES = FileList['lib/**/*', 'spec/*', 'Rakefile', 'README.md', 'VERSION']

spec = Gem::Specification.new do |s|
  s.name = "that_old_cache"
  s.version = "0.0.1"
  s.author = "Joey Robert"
  s.email = "joey@joeyrobert.org"
  s.homepage = "http://github.com/joeyrobert/that_old_cache"
  s.platform = Gem::Platform::RUBY
  s.summary = "Serve old caches from memcached while you update in Rails"
  s.description = "An ActiveSupport MemCache store that requires serves keys until they are explicitly overwritten"
  s.files = PKG_FILES.to_a
  s.require_path = "lib"
  s.has_rdoc = false
  s.add_dependency "yajl-ruby", ">= 0.7.x"
  s.add_dependency "activesupport", ">= 2.3.x"
end

desc 'Packages as a Ruby gem'
Rake::GemPackageTask.new(spec) { |pkg| pkg.gem_spec = spec }
