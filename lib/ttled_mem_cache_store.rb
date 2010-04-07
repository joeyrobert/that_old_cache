require 'active_support'
require 'yajl'

module ActiveSupport
  module Cache
    class TTLedMemCacheStoreException < Exception; end

    class TTLedMemCacheStore < MemCacheStore

      # Adds the following option:
      #   :valid_for => number of seconds from now that the cache with "expire"
      #   :raw is not supported with :valid_raw
      def write(key, value, options = nil)
        if options && options[:valid_for]
          options.delete(:raw)
          super(key, encode({:data => value, :ttl => time_for(options.delete(:valid_for))}), options)
        else
          super(key, value, options)
        end
      end

      # Adds the following option:
      #   :valid_for => true 
      #   :raw is not supported with :valid_raw
      def read(key, options = nil)
        if options && options.delete(:valid_for)
          options.delete(:raw)
          parse(super(key, options))[:data]
        else
          super(key, options)
        end
      end

      # only works for TTLed keys
      def expired?(key)
        ttl(key) < Time.now.to_i
      end

      def ttl(key)
        parse(read(key))[:ttl]
      end

      private

      def time_for(seconds)
        Time.now.to_i + seconds.to_i
      end

      def parse(val)
        Yajl::Parser.new(:symbolize_keys => true).parse(val)
      end

      def encode(val)
        Yajl::Encoder.encode(val)
      end

    end
  end
end
