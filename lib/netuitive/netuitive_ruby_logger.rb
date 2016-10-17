require 'logger'

class CheaterLogger
  attr_accessor :level
  def debug(message)
  end

  def error(message)
  end

  def info(message)
  end
end

class RubyNetuitiveLogger
  class << self
    attr_reader :log
    def setup
      file = RubyConfigManager.property('logLocation', 'NETUITIVE_RUBY_LOG_LOCATION', "#{File.expand_path('../../..', __FILE__)}/log/netuitive.log")
      age = RubyConfigManager.property('logAge', 'NETUITIVE_RUBY_LOG_AGE', 'daily')
      size = RubyConfigManager.property('logSize', 'NETUITIVE_RUBY_LOG_SIZE', nil)
      @log = Logger.new(file, age, size)
    rescue
      puts 'netuitive unable to open log file'
      @log = CheaterLogger.new
    end
  end
end
