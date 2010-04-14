That Old Cache
==============

Description
-----------

Getting sick of memcached just kicking your stuff out of memory in Rails? Maybe you've thought *"Gee, wouldn't it be nice to just serve the old cache while I update it."* Well, look no further! **That Old Cache** is a Rubygem that does just that, giving you the ability to fire off a process to refresh the cache once it expires, without the annoying "initial load" problem that affects your users.

It does this by not using the memcached TTL and storing the expiration time in the memcached value. This way we can serve the old cache while an external process updates it (for example).

Requirements
------------

`activesupport >= 2.3.x`
`yajl-ruby >= 0.7.x`

Quick Example
-------------

Say you have an expensive query used to populate your homepage content that you'd like to be refreshed every two hours. Grabbing this data on page load is a bad idea. We could use the active support memcached store, but every two hours, some poor user will be hit with the burden of a long page load. Here's what we can do:

`environment.rb`

	require 'that_old_cache'

`main_controller.rb`

	def index
	  # Note: this takes the same parameters as ActiveSupport::Cache::MemCacheStore
	  @cache ||= ActiveSupport::Cache::TTLedMemCacheStore.new('localhost')
	  @expensive_data = @cache.read('example_key', :valid_for => true)
	
	  if @cache.expired?('example_key')
	    # this is where you'd send a signal to an external process to refetch
	    # the data (say via a beanstalkd queue, or using BackgrounDRB)
	  end 
	end

`data_fetcher.rb`

	cache = ActiveSupport::Cache::TTLedMemCacheStore.new('localhost')
	expensive_data = SomeReallyLongProcessThing.run
	cache.write('example_key', expensive_data, :valid_for => 2.hours)

Contributors
------------

Joey Robert ([http://joeyrobert.org/](http://joeyrobert.org/))
Brendon Murphy ([http://www.techfreak.net/](http://www.techfreak.net/))
