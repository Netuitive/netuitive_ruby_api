module NetuitiveRubyApi
  class ConfigManager
    class << self
      attr_reader :netuitivedAddr

      attr_reader :netuitivedPort

      attr_reader :data

      def property(name, var, default = nil)
        prop = ENV[var]
        prop = data[name] if prop.nil? || (prop == '')
        return prop unless prop.nil? || (prop == '')
        default
      end

      def boolean_property(name, var)
        prop = ENV[var].nil? ? nil : ENV[var].dup
        if prop.nil? || (prop == '')
          prop = data[name]
        else
          prop.strip!
          prop = prop.casecmp('true').zero?
        end
        prop
      end

      def float_property(name, var)
        prop = ENV[var].nil? ? nil : ENV[var]
        if prop.nil? || (prop == '')
          data[name].to_f
        else
          prop.to_f
        end
      end

      def string_list_property(name, var)
        list = []
        prop = ENV[var].nil? ? nil : ENV[var].dup
        if prop.nil? || (prop == '')
          list = data[name] if !data[name].nil? && data[name].is_a?(Array)
        else
          list = prop.split(',')
        end
        list.each(&:strip!) unless list.empty?
        list
      end

      def load_config
        gem_root = File.expand_path('../../..', __FILE__)
        @data = YAML.load_file "#{gem_root}/config/agent.yml"
      end

      def read_config
        @netuitivedAddr = property('netuitivedAddr', 'NETUITIVE_RUBY_NETUITIVED_ADDR')
        @netuitivedPort = property('netuitivedPort', 'NETUITIVE_RUBY_NETUITIVED_PORT')
        debugLevelString = property('debugLevel', 'NETUITIVE_RUBY_DEBUG_LEVEL')
        NetuitiveRubyApi::NetuitiveLogger.log.level = if debugLevelString == 'error'
                                                        Logger::ERROR
                                                      elsif debugLevelString == 'info'
                                                        Logger::INFO
                                                      elsif debugLevelString == 'debug'
                                                        Logger::DEBUG
                                                      else
                                                        Logger::ERROR
                                                      end
        NetuitiveRubyApi::NetuitiveLogger.log.info "port: #{@netuitivedPort}"
        NetuitiveRubyApi::NetuitiveLogger.log.info "addr: #{@netuitivedAddr}"
        NetuitiveRubyApi::NetuitiveLogger.log.debug "read config file. Results:
          netuitivedAddr: #{@netuitivedAddr}
          netuitivedPort: #{@netuitivedPort}
          debugLevel: #{debugLevelString}"
      end
    end
  end
end
