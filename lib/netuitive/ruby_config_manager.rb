require 'netuitive/netuitive_ruby_logger'
class ConfigManager

	class << self
		def setup()
			readConfig()
		end

		def netuitivedAddr
			@@netuitivedAddr
		end

		def netuitivedPort
			@@netuitivedPort
		end

		def readConfig()
			gem_root= File.expand_path("../../..", __FILE__)
			data=YAML.load_file "#{gem_root}/config/agent.yml"
			@@netuitivedAddr=data["netuitivedAddr"]
			@@netuitivedPort=data["netuitivedPort"]
			NetuitiveLogger.log.info "port: #{@@netuitivedPort}"
			NetuitiveLogger.log.info "addr: #{@@netuitivedAddr}"
			debugLevelString=data["debugLevel"]
			if debugLevelString == "error"
				NetuitiveLogger.log.level = Logger::ERROR
			elsif debugLevelString == "info"
				NetuitiveLogger.log.level = Logger::INFO
			elsif debugLevelString == "debug"
				NetuitiveLogger.log.level = Logger::DEBUG
			else
				NetuitiveLogger.log.level = Logger::ERROR
			end
			NetuitiveLogger.log.debug "read config file. Results: 
				netuitivedAddr: #{@@netuitivedAddr}
				netuitivedPort: #{@@netuitivedPort}
				debugLevel: #{debugLevelString}"
		end
	end
end 
