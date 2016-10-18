require 'logger'
module NetuitiveRubyApi
  class CheaterLogger
    attr_accessor :level
    def debug(message)
    end

    def error(message)
    end

    def info(message)
    end
  end

  class NetuitiveLogger
    class << self
      attr_reader :log
      def setup
        file = NetuitiveRubyApi::ConfigManager.property('logLocation', 'NETUITIVE_RUBY_LOG_LOCATION', "#{File.expand_path('../../..', __FILE__)}/log/netuitive.log")
        age = NetuitiveRubyApi::ConfigManager.property('logAge', 'NETUITIVE_RUBY_LOG_AGE', 'daily')
        age = format_age(age)
        size = NetuitiveRubyApi::ConfigManager.property('logSize', 'NETUITIVE_RUBY_LOG_SIZE', 1_000_000)
        size = format_size(size)
        @log = Logger.new(file, age, size)
      rescue => e
        puts "netuitive unable to open log file. error: #{e.message}, backtrace: #{e.backtrace}"
        @log = NetuitiveRubyApi::CheaterLogger.new
      end

      def format_age(age)
        return 'daily' if age.nil?
        begin
          Integer(age)
        rescue
          age
        end
      end

      def format_size(size)
        return 1_000_000 if size.nil?
        begin
          Integer(size)
        rescue
          size
        end
      end
    end
  end
end
