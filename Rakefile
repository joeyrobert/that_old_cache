require 'rake'
require 'rake/gempackagetask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "that_old_cache"
    s.summary = "Serve old caches from memcached while you update in Rails"
    s.description = s.summary
    s.author = "Joey Robert"
    s.email = "joey@joeyrobert.org"
    s.homepage = "http://github.com/joeyrobert/that_old_cache"
    s.add_dependency("yajl-ruby", ">= 0.7.5")
    s.add_dependency("activesupport", ">= 2.3.5")
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
