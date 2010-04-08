require File.dirname(__FILE__) + '/spec_helper'

describe ActiveSupport::Cache::TTLedMemCacheStore do
  # Since this is about interface to a cache, I think it makes sense to run a 
  # real cache in this case and not mock/stub it out.  TODO: Rake to start/detach
  # a memcached?
  before(:all) do
    begin
      # Run on non-default port so not to accidentally mess with a real cache
      @cache = ActiveSupport::Cache::TTLedMemCacheStore.new("127.0.0.1:12345")
      # Call to make sure we have a live connection
      @cache.exist?("cache_key")
    rescue => e
      $stderr.puts e.message
      $stderr.puts "Make sure memcached is listening on tcpport 12345: /path/to/memcached -p 12345"
      exit
    end
    
    @key = "example_key"
    @value = "example_value"
  end
  
  after(:each) do
    @cache.clear
  end
  
  context "ttl'd keys" do
    before(:each) do
      @valid_for = 10
      @cache.write(@key, @value, :valid_for => @valid_for)
    end
    
    it "should set the expected value in the cache" do
      @cache.read(@key, :valid_for => true).should == @value
    end
    
    it "should have the proper ttl" do
      @cache.ttl(@key).should be_close(Time.now.to_i + @valid_for, 1)
    end
    
    # Vendor something to time_travel if this sleep stuff gets annoying
    it "should be expired if the ttl is less than now" do
      @cache.write("expired_ttl", "value", :valid_for => 0.1)
      sleep 1
      @cache.expired?("expired_ttl").should be_true
    end
    
    it "should not be expired if the ttl is greater than now" do
      @cache.write("expired_ttl", "value", :valid_for => 5)
      @cache.expired?("expired_ttl").should be_false
    end
  end

  context "non-ttl'd keys" do
    before(:each) do
      @cache.write(@key, @value)
    end
    
    it "should set the non-serialized value in the cache" do
      @cache.read(@key).should == @value
    end
    
    it "should have a nil ttl" do
      @cache.ttl(@key).should be_nil
    end
    
    it "should not be expired" do
      @cache.expired?(@key).should be_false
    end
    
    it "should not raise an exception if trying a ttl'd read on a non-ttl'd key" do
      lambda { @cache.read(@key, :valid_for => true) }.should_not raise_error
    end

    it "should return nil if trying a ttl'd read on a non-ttl'd key" do
      @cache.read(@key, :valid_for => true).should be_nil
    end
  end  
end