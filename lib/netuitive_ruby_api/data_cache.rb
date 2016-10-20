module NetuitiveRubyApi
  class DataCache
    class << self
      def exception_events
        @@exception_events
      end

      def events
        @@events
      end

      def aggregate_counter_metrics
        @@aggregate_counter_metrics
      end

      def aggregate_metrics
        @@aggregate_metrics
      end

      def counter_samples
        @@counter_samples
      end

      def sample_count
        @@sample_count
      end

      def event_count
        @@event_count
      end

      def sample_count_mutex
        @@sample_count_mutex
      end

      def event_count_mutex
        @@event_count_mutex
      end

      def samples
        @@samples
      end

      def setup
        @@sample_count_mutex = Mutex.new
        @@event_count_mutex = Mutex.new
        reset_samples
        reset_events
      end

      def sample_added
        @@sample_count += 1
      end

      def event_added
        @@event_count += 1
      end

      def reset_samples
        @@samples = []
        @@counter_samples = []
        @@aggregate_metrics = []
        @@aggregate_counter_metrics = []
        @@sample_count = 0
      end

      def reset_events
        NetuitiveRubyApi::NetuitiveLogger.log.debug 'reseting event cache'
        @@events = []
        @@exception_events = []
        @@event_count = 0
        NetuitiveRubyApi::NetuitiveLogger.log.debug "exception_events array: #{@@exception_events.object_id}"
      end
    end
  end
end
