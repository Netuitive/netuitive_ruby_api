module NetuitiveRubyApi
  class ConfigManager
    class << self
      attr_reader :netuitivedAddr
      attr_reader :netuitivedPort
      attr_reader :data
      attr_reader :sample_cache_enabled
      attr_reader :sample_cache_size
      attr_reader :sample_cache_interval
      attr_reader :event_cache_enabled
      attr_reader :event_cache_size
      attr_reader :event_cache_interval

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
        property(name, var).to_f
      end

      def int_property(name, var)
        property(name, var).to_i
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
        @sample_cache_enabled = boolean_property('sampleCacheEnabled', 'NETUITIVE_RUBY_SAMPLE_CACHE_ENABLED')
        @sample_cache_size = int_property('sampleCacheSize', 'NETUITIVE_RUBY_SAMPLE_CACHE_SIZE')
        @sample_cache_interval = int_property('sampleCacheInterval', 'NETUITIVE_RUBY_SAMPLE_CACHE_INTERVAL')
        @event_cache_enabled = boolean_property('eventCacheEnabled', 'NETUITIVE_RUBY_EVENT_CACHE_ENABLED')
        @event_cache_size = int_property('eventCacheSize', 'NETUITIVE_RUBY_SAMPLE_CACHE_SIZE')
        @event_cache_interval = int_property('eventCacheInterval', 'NETUITIVE_RUBY_SAMPLE_CACHE_INTERVAL')
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
        NetuitiveRubyApi::NetuitiveLogger.log.info "netuitived port: #{@netuitivedPort}"
        NetuitiveRubyApi::NetuitiveLogger.log.info "netuitived addr: #{@netuitivedAddr}"
        NetuitiveRubyApi::NetuitiveLogger.log.debug "read config file. Results:
          netuitivedAddr: #{@netuitivedAddr}
          netuitivedPort: #{@netuitivedPort}
          debugLevel: #{debugLevelString}
          sample_cache_enabled: #{@sample_cache_enabled}
          sample_cache_size: #{@sample_cache_size}
          sample_cache_interval: #{@sample_cache_interval}
          event_cache_enabled: #{@event_cache_enabled}
          event_cache_size: #{@event_cache_size}
          event_cache_interval: #{@event_cache_interval}"
      end
    end
  end
end
