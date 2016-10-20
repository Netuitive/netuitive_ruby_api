module NetuitiveRubyApi
  class DataCacheInteraction
    def initialize
      NetuitiveRubyApi::DataCache.setup
    end

    def add_sample(value)
      NetuitiveRubyApi::DataCache.sample_count_mutex.synchronize do
        NetuitiveRubyApi::DataCache.samples.push(value)
        NetuitiveRubyApi::DataCache.sample_added
      end
    end

    def add_counter_sample(value)
      NetuitiveRubyApi::DataCache.sample_count_mutex.synchronize do
        NetuitiveRubyApi::DataCache.counter_samples.push(value)
        NetuitiveRubyApi::DataCache.sample_added
      end
    end

    def add_aggregate_metric(value)
      NetuitiveRubyApi::DataCache.sample_count_mutex.synchronize do
        NetuitiveRubyApi::DataCache.aggregate_metrics.push(value)
        NetuitiveRubyApi::DataCache.sample_added
      end
    end

    def add_aggregate_counter_metric(value)
      NetuitiveRubyApi::DataCache.sample_count_mutex.synchronize do
        NetuitiveRubyApi::DataCache.aggregate_counter_metrics.push(value)
        NetuitiveRubyApi::DataCache.sample_added
      end
    end

    def add_event(value)
      NetuitiveRubyApi::DataCache.event_count_mutex.synchronize do
        NetuitiveRubyApi::DataCache.events.push(value)
        NetuitiveRubyApi::DataCache.event_added
      end
    end

    def add_exception_event(value)
      NetuitiveRubyApi::DataCache.event_count_mutex.synchronize do
        NetuitiveRubyApi::DataCache.exception_events.push(value)
        NetuitiveRubyApi::NetuitiveLogger.log.debug "exception_events array: #{NetuitiveRubyApi::DataCache.exception_events.object_id}"
        NetuitiveRubyApi::NetuitiveLogger.log.debug "exception_events array size: #{NetuitiveRubyApi::DataCache.exception_events.size}"
        NetuitiveRubyApi::DataCache.event_added
      end
    end

    def clear_sample_cache
      NetuitiveRubyApi::ErrorLogger.guard('error during clear_sample_cache') do
        NetuitiveRubyApi::DataCache.sample_count_mutex.synchronize do
          NetuitiveRubyApi::NetuitiveLogger.log.debug 'clearing sample cache'
          ret = {
            samples: NetuitiveRubyApi::DataCache.samples.dup,
            counter_samples: NetuitiveRubyApi::DataCache.counter_samples.dup,
            aggregate_metrics: NetuitiveRubyApi::DataCache.aggregate_metrics.dup,
            aggregate_counter_metrics: NetuitiveRubyApi::DataCache.aggregate_counter_metrics.dup
          }
          NetuitiveRubyApi::DataCache.reset_samples
          ret
        end
      end
    end

    def clear_event_cache
      NetuitiveRubyApi::ErrorLogger.guard('error during clear_event_cache') do
        NetuitiveRubyApi::DataCache.event_count_mutex.synchronize do
          NetuitiveRubyApi::NetuitiveLogger.log.debug 'clearing event cache'
          NetuitiveRubyApi::NetuitiveLogger.log.debug "exception_events array: #{NetuitiveRubyApi::DataCache.exception_events.object_id}"
          NetuitiveRubyApi::NetuitiveLogger.log.debug "exception_events array size: #{NetuitiveRubyApi::DataCache.exception_events.size}"
          ret = {
            events: NetuitiveRubyApi::DataCache.events.dup,
            exception_events: NetuitiveRubyApi::DataCache.exception_events.dup
          }
          NetuitiveRubyApi::DataCache.reset_events
          ret
        end
      end
    end
  end
end
