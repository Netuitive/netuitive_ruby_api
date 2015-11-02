class ConfigManager

	class << self
		def setup()
			@@error=0
			@@info=1
			@@debug=2
			readConfig()
		end

		def netuitivedAddr
			@@netuitivedAddr
		end

		def netuitivedPort
			@@netuitivedPort
		end

		def isDebug?
			if @@debugLevel >= @@debug
				return true
			end
			return false
		end

		def isInfo?
			if @@debugLevel >= @@info
				return true
			end
			return false
		end

		def isError?
			if @@debugLevel >= @@error
				return true
			end
			return false
		end

		def readConfig()
			gem_root= File.expand_path("../../..", __FILE__)
			data=YAML.load_file "#{gem_root}/config/agent.yml"
			@@netuitivedAddr=data["netuitivedAddr"]
			@@netuitivedPort=data["netuitivedPort"]
			puts "port: #{@@netuitivedPort}"
			puts "addr: #{@@netuitivedAddr}"
			debugLevelString=data["debugLevel"]
			if debugLevelString == "error"
				@@debugLevel=@@error
			elsif debugLevelString == "info"
				@@debugLevel=@@info
			elsif debugLevelString == "debug"
				@@debugLevel=@@debug
			else
				@@debugLevel=@@error
			end

			if isDebug?
				puts "read config file. Results: 
				netuitivedAddr: #{@@netuitivedAddr}
				netuitivedPort: #{@@netuitivedPort}
				debugLevel: #{debugLevelString}"
			end
		end
	end
end 
