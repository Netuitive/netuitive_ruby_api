module NetuitiveRubyApi
  class NetuitiveRubyAPITest < Test::Unit::TestCase
    def setup
      @netuitived_server = mock
      @data_manager = mock
      NetuitiveRubyAPI.setup(@netuitived_server, @data_manager)
      NetuitiveRubyApi::NetuitiveLogger.setup
    end

    def test_stop_server
      @netuitived_server.expects(:stopServer).once
      NetuitiveRubyAPI.stop_server
    end

    def test_send_metrics
      @netuitived_server.expects(:sendMetrics).once
      NetuitiveRubyAPI.send_metrics
    end

    def test_clear_metrics
      @netuitived_server.expects(:clearMetrics).once
      NetuitiveRubyAPI.clear_metrics
    end

    def test_add_sample
      @data_manager.expects(:add_sample).once.with('test.id', 5)
      NetuitiveRubyAPI.add_sample('test.id', 5)
    end

    def test_interval
      @netuitived_server.stubs(:interval).returns(60)
      interval = NetuitiveRubyAPI.interval
      assert_equal(interval, 60)
    end

    def test_event
      @data_manager.expects(:event).once.with('test message', Time.new(2000, 1, 1, 1, 1, 1), 'Ruby Event', 'Info', 'Ruby Agent', 'INFO', nil)
      NetuitiveRubyAPI.event('test message', Time.new(2000, 1, 1, 1, 1, 1))
    end

    def test_exception_event
      error = RuntimeError.new
      @data_manager.expects(:exception_event).once.with(error, nil, nil)
      NetuitiveRubyAPI.exception_event(error)
      begin
        raise 'test exception'
      rescue => e
        @data_manager.expects(:exception_event).once.with(e, nil, nil)
        NetuitiveRubyAPI.exception_event(e)
      end
    end

    def test_add_counter_sample
      @data_manager.expects(:add_counter_sample).once.with('test.id', 5)
      NetuitiveRubyAPI.add_counter_sample('test.id', 5)
    end

    def test_aggregate_metric
      @data_manager.expects(:aggregate_metric).once.with('test.id', 5)
      NetuitiveRubyAPI.aggregate_metric('test.id', 5)
    end

    def test_aggregate_counter_metric
      @data_manager.expects(:aggregate_counter_metric).once.with('test.id', 5)
      NetuitiveRubyAPI.aggregate_counter_metric('test.id', 5)
    end
  end
end
