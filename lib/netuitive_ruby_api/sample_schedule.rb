module NetuitiveRubyApi
  class SampleSchedule
    def self.start(interval)
      @@thread = Thread.new do
        loop do
          sleep(interval)
          Thread.new do
            NetuitiveRubyApi::NetuitiveLogger.log.debug 'started sample job'
            NetuitiveRubyApi::ErrorLogger.guard('error during sample job') do
              NetuitiveRubyAPI.flush_samples
            end
            NetuitiveRubyApi::NetuitiveLogger.log.debug 'finished sample job'
          end
        end
      end
    end

    def self.stop
      @@thread.kill if defined? @@thread
    end
  end
end
