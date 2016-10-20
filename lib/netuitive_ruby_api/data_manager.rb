module NetuitiveRubyApi
  class DataManager
    attr_accessor :data_cache
    attr_accessor :sample_cache_enabled
    attr_accessor :sample_cache_size
    attr_accessor :sample_cache_interval
    attr_accessor :event_cache_enabled
    attr_accessor :event_cache_size
    attr_accessor :event_cache_interval
    attr_accessor :netuitived_server

    def add_sample(metric_id, val)
      if @sample_cache_enabled
        NetuitiveRubyApi::NetuitiveLogger.log.debug "adding sample to cache: #{metric_id}"
        sample_cache_addition { data_cache.add_sample(metric_id: metric_id, val: val) }
      else
        server_interaction { netuitived_server.addSample(metric_id, val) }
      end
    end

    def add_counter_sample(metric_id, val)
      if @sample_cache_enabled
        NetuitiveRubyApi::NetuitiveLogger.log.debug "adding sample to cache: #{metric_id}"
        sample_cache_addition { data_cache.add_counter_sample(metric_id: metric_id, val: val) }
      else
        server_interaction { netuitived_server.addCounterSample(metric_id, val) }
      end
    end

    def aggregate_metric(metric_id, val)
      if @sample_cache_enabled
        NetuitiveRubyApi::NetuitiveLogger.log.debug "adding sample to cache: #{metric_id}"
        sample_cache_addition { data_cache.add_aggregate_metric(metric_id: metric_id, val: val) }
      else
        server_interaction { netuitived_server.aggregateMetric(metric_id, val) }
      end
    end

    def aggregate_counter_metric(metric_id, val)
      if @sample_cache_enabled
        NetuitiveRubyApi::NetuitiveLogger.log.debug "adding sample to cache: #{metric_id}"
        sample_cache_addition { data_cache.add_aggregate_counter_metric(metric_id: metric_id, val: val) }
      else
        server_interaction { netuitived_server.aggregateCounterMetric(metric_id, val) }
      end
    end

    def event(message, timestamp, title, level, source, type, tags)
      if @event_cache_enabled
        NetuitiveRubyApi::NetuitiveLogger.log.debug "adding event to cache: #{message}"
        event_cache_addition do
          data_cache.add_event(message: message,
                               timestamp: timestamp,
                               title: title,
                               level: level,
                               source: source,
                               type: type,
                               tags: tags)
        end
      else
        server_interaction { netuitived_server.event(message, timestamp, title, level, source, type, tags) }
      end
    end

    def exception_event(exception, klass, tags)
      NetuitiveRubyApi::ErrorLogger.guard('error during exception_event') do
        hash = { message: exception.message }
        hash[:backtrace] = exception.backtrace.join("\n\t") if (defined? exception.backtrace) && !exception.backtrace.nil?
        NetuitiveRubyApi::NetuitiveLogger.log.debug "data cache: #{data_cache}"
        if @event_cache_enabled
          NetuitiveRubyApi::NetuitiveLogger.log.debug "adding exception event to cache: #{hash[:message]}"
          event_cache_addition do
            data_cache.add_exception_event(exception: hash,
                                           klass: klass,
                                           tags: tags)
          end
        else
          server_interaction { netuitived_server.exceptionEvent(hash, klass, tags) }
        end
      end
    end

    def flush_samples
      NetuitiveRubyApi::ErrorLogger.guard('error during flush_samples') do
        sample = data_cache.clear_sample_cache
        NetuitiveRubyApi::NetuitiveLogger.log.info "sending #{sample[:samples].size + sample[:counter_samples].size + sample[:aggregate_metrics].size + sample[:aggregate_counter_metrics].size} samples"
        threads = []
        threads << server_interaction do
          NetuitiveRubyApi::NetuitiveLogger.log.debug "sending samples: #{sample[:samples]} "
          netuitived_server.add_samples sample[:samples]
        end unless sample[:samples].empty?
        threads << server_interaction do
          NetuitiveRubyApi::NetuitiveLogger.log.debug "sending counter_samples: #{sample[:counter_samples]} "
          netuitived_server.add_counter_samples sample[:counter_samples]
        end unless sample[:counter_samples].empty?
        threads << server_interaction do
          NetuitiveRubyApi::NetuitiveLogger.log.debug "sending aggregate_metrics: #{sample[:aggregate_metrics]} "
          netuitived_server.add_aggregate_metrics sample[:aggregate_metrics]
        end unless sample[:aggregate_metrics].empty?
        threads << server_interaction do
          NetuitiveRubyApi::NetuitiveLogger.log.debug "sending aggregate_counter_metrics: #{sample[:aggregate_counter_metrics]} "
          netuitived_server.add_aggregate_counter_metrics sample[:aggregate_counter_metrics]
        end unless sample[:aggregate_counter_metrics].empty?
        threads
      end
    end

    def flush_events
      NetuitiveRubyApi::NetuitiveLogger.log.debug "event_cache: #{data_cache.instance_variable_get(:@exception_events)}"
      NetuitiveRubyApi::ErrorLogger.guard('error during flush_events') do
        event_cache = data_cache.clear_event_cache
        NetuitiveRubyApi::NetuitiveLogger.log.debug "event_cache: #{event_cache}"
        NetuitiveRubyApi::NetuitiveLogger.log.info "sending #{event_cache[:events].size + event_cache[:exception_events].size} events"
        threads = []
        threads << server_interaction do
          NetuitiveRubyApi::NetuitiveLogger.log.debug "sending events: #{event_cache[:events]} "
          netuitived_server.add_events(event_cache[:events])
        end unless event_cache[:events].empty?
        threads << server_interaction do
          NetuitiveRubyApi::NetuitiveLogger.log.debug "sending exception_events: #{event_cache[:exception_events]} "
          netuitived_server.add_exception_events(event_cache[:exception_events])
        end unless event_cache[:exception_events].empty?
        threads
      end
    end

    def sample_cache_addition
      flush_samples if yield >= @sample_cache_size
    end

    def event_cache_addition
      flush_events if yield >= @event_cache_size
    end

    def server_interaction
      Thread.new do
        NetuitiveRubyApi::ErrorLogger.guard('error during server interaction') { yield }
      end
    end
  end
end
