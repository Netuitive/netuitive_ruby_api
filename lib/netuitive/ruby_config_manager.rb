require 'netuitive/netuitive_ruby_logger'
require 'yaml'
class ConfigManager
  class << self
    def setup
      readConfig
    end

    def netuitivedAddr
      @@netuitivedAddr
    end

    def netuitivedPort
      @@netuitivedPort
    end

    def readConfig
      gem_root = File.expand_path('../../..', __FILE__)
      data = YAML.load_file "#{gem_root}/config/agent.yml"
      @@netuitivedAddr = ENV['NETUITIVE_RUBY_NETUITIVED_ADDR']
      if @@netuitivedAddr.nil? || (@@netuitivedAddr == '')
        @@netuitivedAddr = data['netuitivedAddr']
      end
      @@netuitivedPort = ENV['NETUITIVE_RUBY_NETUITIVED_PORT']
      if @@netuitivedPort.nil? || (@@netuitivedPort == '')
        @@netuitivedPort = data['netuitivedPort']
      end
      debugLevelString = ENV['NETUITIVE_RUBY_DEBUG_LEVEL']
      if debugLevelString.nil? || (debugLevelString == '')
        debugLevelString = data['debugLevel']
      end
      NetuitiveLogger.log.info "port: #{@@netuitivedPort}"
      NetuitiveLogger.log.info "addr: #{@@netuitivedAddr}"
      NetuitiveLogger.log.level = if debugLevelString == 'error'
                                    Logger::ERROR
                                  elsif debugLevelString == 'info'
                                    Logger::INFO
                                  elsif debugLevelString == 'debug'
                                    Logger::DEBUG
                                  else
                                    Logger::ERROR
                                  end
      NetuitiveLogger.log.debug "read config file. Results:
        netuitivedAddr: #{@@netuitivedAddr}
        netuitivedPort: #{@@netuitivedPort}
        debugLevel: #{debugLevelString}"
    end
  end
end
