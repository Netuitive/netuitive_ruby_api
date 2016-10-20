require 'yaml'
require 'logger'
require 'drb/drb'
require 'netuitive_ruby_api/config_manager'
require 'netuitive_ruby_api/netuitive_logger'
require 'netuitive_ruby_api/error_logger'
require 'netuitive_ruby_api/data_cache'
require 'netuitive_ruby_api/data_cache_interaction'
require 'netuitive_ruby_api/data_manager'
require 'netuitive_ruby_api/event_schedule'
require 'netuitive_ruby_api/sample_schedule'

class NetuitiveRubyAPI
  class << self
    def setup(server, data_manager)
      @@netuitivedServer = server
      @@data_manager = data_manager
    end

    def flush_samples
      @@data_manager.flush_samples
    end

    def flush_events
      @@data_manager.flush_events
    end

    def netuitivedServer
      @@netuitivedServer
    end

    def send_metrics
      netuitivedServer.sendMetrics
    end

    def add_sample(metric_id, val)
      @@data_manager.add_sample(metric_id, val)
    end

    def add_counter_sample(metric_id, val)
      @@data_manager.add_counter_sample(metric_id, val)
    end

    def aggregate_metric(metric_id, val)
      @@data_manager.aggregate_metric(metric_id, val)
    end

    def aggregate_counter_metric(metric_id, val)
      @@data_manager.aggregate_counter_metric(metric_id, val)
    end

    def clear_metrics
      netuitivedServer.clearMetrics
    end

    def interval
      netuitivedServer.interval # synchronous for return value
    end

    def event(message, timestamp = Time.new, title = 'Ruby Event', level = 'Info', source = 'Ruby Agent', type = 'INFO', tags = nil)
      @@data_manager.event(message, timestamp, title, level, source, type, tags)
    end

    def exception_event(exception, klass = nil, tags = nil)
      @@data_manager.exception_event(exception, klass, tags)
    end

    def stop_server
      netuitivedServer.stopServer
    end
  end
end

NetuitiveRubyApi::ConfigManager.load_config
NetuitiveRubyApi::NetuitiveLogger.setup
NetuitiveRubyApi::ConfigManager.read_config

NetuitiveRubyApi::ErrorLogger.guard('error during api setup') do
  SERVER_URI = "druby://#{NetuitiveRubyApi::ConfigManager.netuitivedAddr}:#{NetuitiveRubyApi::ConfigManager.netuitivedPort}".freeze
  DRb.start_service
  drb_server = DRbObject.new_with_uri(SERVER_URI)
  data_manager = NetuitiveRubyApi::DataManager.new
  data_manager.data_cache = NetuitiveRubyApi::DataCacheInteraction.new
  data_manager.sample_cache_enabled = NetuitiveRubyApi::ConfigManager.sample_cache_enabled
  data_manager.sample_cache_size = NetuitiveRubyApi::ConfigManager.sample_cache_size
  data_manager.sample_cache_interval = NetuitiveRubyApi::ConfigManager.sample_cache_interval
  data_manager.event_cache_enabled = NetuitiveRubyApi::ConfigManager.event_cache_enabled
  data_manager.event_cache_size = NetuitiveRubyApi::ConfigManager.event_cache_size
  data_manager.event_cache_interval = NetuitiveRubyApi::ConfigManager.event_cache_interval
  data_manager.netuitived_server = drb_server
  NetuitiveRubyAPI.setup(drb_server, data_manager)
end
NetuitiveRubyApi::SampleSchedule.start(NetuitiveRubyApi::ConfigManager.sample_cache_interval) if NetuitiveRubyApi::ConfigManager.sample_cache_enabled
NetuitiveRubyApi::EventSchedule.start(NetuitiveRubyApi::ConfigManager.event_cache_interval) if NetuitiveRubyApi::ConfigManager.event_cache_enabled
