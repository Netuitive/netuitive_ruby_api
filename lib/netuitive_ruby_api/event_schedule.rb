module NetuitiveRubyApi
  class EventSchedule
    def self.start(interval)
      @@thread = Thread.new do
        loop do
          sleep(interval)
          Thread.new do
            NetuitiveRubyApi::NetuitiveLogger.log.debug 'started event job'
            NetuitiveRubyApi::ErrorLogger.guard('error during event job') do
              NetuitiveRubyAPI.flush_events
            end
            NetuitiveRubyApi::NetuitiveLogger.log.debug 'finished event job'
          end
        end
      end
    end

    def self.stop
      @@thread.kill if defined? @@thread
    end
  end
end
