require 'active_support'
require 'yajl'

module ActiveSupport
  module Cache
    class MemCacheStore
      alias :write_original :write
      alias :read_original :read

      # Adds the following option:
      #   :valid_until => Time object, or integer
      #   :raw => Overrides :valid_until
      def write(key, value, options = nil)
        if options && options[:valid_until] && !raw?(options)
          write_original(key, encode({:data => value, :ttl => time_for(options.delete(:valid_until))}), options)
        else
          write_original(key, value, options)
        end
      end

      # Adds the following option:
      #   :valid_until => true 
      #   :raw => Overrides :valid_until
      def read(key, options = nil)
        if options && options.delete(:valid_until) && !raw?(options)
          parse(read_original(key, options))[:data]
        else
          read_original(key, options)
        end
      end

      # only works for TTLed keys
      def expired?(key)
        parse(read_original(key))[:ttl] < Time.now.to_i
      end

      def ttl_for(key)
        parse(read_original(key))[:ttl]
      end

      private

      # returns a timestamp
      def time_for(time)
        if time.is_a?(Time) || time.is_a?(String)
          time.to_i
        elsif time.is_a?(Integer)
          time
        else
          nil
        end
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
