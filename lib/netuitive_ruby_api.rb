require 'netuitive/ruby_config_manager'
require 'drb/drb'
class NetuitiveRubyAPI
  class << self
    def setup(server)
      @@netuitivedServer = server
    end

    def netuitivedServer
      @@netuitivedServer
    end
  end
end
ConfigManager.setup
SERVER_URI = "druby://#{ConfigManager.netuitivedAddr}:#{ConfigManager.netuitivedPort}".freeze
DRb.start_service
NetuitiveRubyAPI.setup(DRbObject.new_with_uri(SERVER_URI))
