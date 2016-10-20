module NetuitiveRubyApi
  class DataCache
    def initialize
      @sample_count_mutex = Mutex.new
      @event_count_mutex = Mutex.new
      reset_samples
      reset_events
    end

    def sample_added
      @sample_count += 1
    end

    def event_added
      @event_count += 1
    end

    def add_sample(value)
      @sample_count_mutex.synchronize do
        @samples.push(value)
        sample_added
      end
    end

    def add_counter_sample(value)
      @sample_count_mutex.synchronize do
        @counter_samples.push(value)
        sample_added
      end
    end

    def add_aggregate_metric(value)
      @sample_count_mutex.synchronize do
        @aggregate_metrics.push(value)
        sample_added
      end
    end

    def add_aggregate_counter_metric(value)
      @sample_count_mutex.synchronize do
        @aggregate_counter_metrics.push(value)
        sample_added
      end
    end

    def add_event(value)
      @event_count_mutex.synchronize do
        @events.push(value)
        event_added
      end
    end

    def add_exception_event(value)
      @event_count_mutex.synchronize do
        @exception_events.push(value)
        event_added
      end
    end

    def clear_sample_cache
      NetuitiveRubyApi::ErrorLogger.guard('error during clear_sample_cache') do
        @sample_count_mutex.synchronize do
          NetuitiveRubyApi::NetuitiveLogger.log.debug 'clearing sample cache'
          ret = {
            samples: @samples.dup,
            counter_samples: @counter_samples.dup,
            aggregate_metrics: @aggregate_metrics.dup,
            aggregate_counter_metrics: @aggregate_counter_metrics.dup
          }
          reset_samples
          ret
        end
      end
    end

    def clear_event_cache
      NetuitiveRubyApi::ErrorLogger.guard('error during clear_event_cache') do
        @event_count_mutex.synchronize do
          NetuitiveRubyApi::NetuitiveLogger.log.debug 'clearing event cache'
          ret = {
            events: @events.dup,
            exception_events: @exception_events.dup
          }
          reset_events
          ret
        end
      end
    end

    def reset_samples
      @samples = []
      @counter_samples = []
      @aggregate_metrics = []
      @aggregate_counter_metrics = []
      @sample_count = 0
    end

    def reset_events
      @events = []
      @exception_events = []
      @event_count = 0
    end
  end
end
