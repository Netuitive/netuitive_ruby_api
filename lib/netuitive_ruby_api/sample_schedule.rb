module NetuitiveRubyApi
  class SampleSchedule
    def self.start(interval)
      Thread.new do
        loop do
          sleep(interval)
          Thread.new do
            NetuitiveRubyApi::NetuitiveLogger.log.debug 'started sample job'
            NetuitiveRubyApi::ErrorLogger.guard('error during sample job') { NetuitiveRubyAPI.flush_samples }
            NetuitiveRubyApi::NetuitiveLogger.log.debug 'finished sample job'
          end
        end
      end
    end
  end
end
