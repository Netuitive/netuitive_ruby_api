require 'yaml'
require 'drb/drb'
require 'netuitive_ruby_api/config_manager'
require 'netuitive_ruby_api/netuitive_logger'

class NetuitiveRubyAPI
  class << self
    def setup(server)
      @@netuitivedServer = server
    end

    def netuitivedServer
      @@netuitivedServer
    end

    def send_metrics
      server_interaction { netuitivedServer.sendMetrics }
    end

    def add_sample(metric_id, val)
      server_interaction { netuitivedServer.addSample(metric_id, val) }
    end

    def add_counter_sample(metric_id, val)
      server_interaction { netuitivedServer.addCounterSample(metric_id, val) }
    end

    def aggregate_metric(metric_id, val)
      server_interaction { netuitivedServer.aggregateMetric(metric_id, val) }
    end

    def aggregate_counter_metric(metric_id, val)
      server_interaction { netuitivedServer.aggregateCounterMetric(metric_id, val) }
    end

    def clear_metrics
      server_interaction { netuitivedServer.clearMetrics }
    end

    def interval
      netuitivedServer.interval # synchronous for return value
    end

    def event(message, timestamp = Time.new, title = 'Ruby Event', level = 'Info', source = 'Ruby Agent', type = 'INFO', tags = nil)
      server_interaction { netuitivedServer.event(message, timestamp, title, level, source, type, tags) }
    end

    def exception_event(exception, klass = nil, tags = nil)
      server_interaction { netuitivedServer.exceptionEvent(exception, klass, tags) }
    end

    def stop_server
      server_interaction { netuitivedServer.stopServer }
    end

    def server_interaction
      Thread.new do
        begin
          yield
        rescue => e
          NetuitiveRubyApi::NetuitiveLogger.log.error "unable to connect to netuitived: message:#{e.message} backtrace:#{e.backtrace}"
        end
      end
    end
  end
end

NetuitiveRubyApi::ConfigManager.load_config
NetuitiveRubyApi::NetuitiveLogger.setup
NetuitiveRubyApi::ConfigManager.read_config
SERVER_URI = "druby://#{NetuitiveRubyApi::ConfigManager.netuitivedAddr}:#{NetuitiveRubyApi::ConfigManager.netuitivedPort}".freeze
DRb.start_service
NetuitiveRubyAPI.setup(DRbObject.new_with_uri(SERVER_URI))
