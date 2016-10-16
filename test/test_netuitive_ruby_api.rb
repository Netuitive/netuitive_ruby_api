require 'test/unit'
require 'mocha/test_unit'
require 'netuitive_ruby_api'
require 'netuitive/netuitive_ruby_logger'

class NetuitiveRubyAPITest < Test::Unit::TestCase
  def setup
    @netuitived_server = mock
    NetuitiveRubyAPI.setup(@netuitived_server)
    NetuitiveLogger.setup
  end

  def test_stop_server
    @netuitived_server.expects(:stopServer).once
    thread = NetuitiveRubyAPI.stop_server
    thread.join
  end

  def test_send_metrics
    @netuitived_server.expects(:sendMetrics).once
    thread = NetuitiveRubyAPI.send_metrics
    thread.join
  end

  def test_clear_metrics
    @netuitived_server.expects(:clearMetrics).once
    thread = NetuitiveRubyAPI.clear_metrics
    thread.join
  end

  def test_add_sample
    @netuitived_server.expects(:addSample).once.with('test.id', 5)
    thread = NetuitiveRubyAPI.add_sample('test.id', 5)
    thread.join
  end

  def test_interval
    @netuitived_server.stubs(:interval).returns(60)
    interval = NetuitiveRubyAPI.interval
    assert_equal(interval, 60)
  end

  def test_event
    @netuitived_server.expects(:event).once.with('test message', Time.new(2000, 1, 1, 1, 1, 1), 'Ruby Event', 'Info', 'Ruby Agent', 'INFO', nil)
    thread = NetuitiveRubyAPI.event('test message', Time.new(2000, 1, 1, 1, 1, 1))
    thread.join
  end

  def test_exception_event
    @netuitived_server.expects(:exceptionEvent).once.with(RuntimeError.new, nil, nil)
    thread = NetuitiveRubyAPI.exception_event(RuntimeError.new)
    thread.join
  end

  def test_add_counter_sample
    @netuitived_server.expects(:addCounterSample).once.with('test.id', 5)
    thread = NetuitiveRubyAPI.add_counter_sample('test.id', 5)
    thread.join
  end

  def test_aggregate_metric
    @netuitived_server.expects(:aggregateMetric).once.with('test.id', 5)
    thread = NetuitiveRubyAPI.aggregate_metric('test.id', 5)
    thread.join
  end

  def aggregate_counter_metric
    @netuitived_server.expects(:aggregateCounterMetric).once.with('test.id', 5)
    thread = NetuitiveRubyAPI.aggregate_counter_metric('test.id', 5)
    thread.join
  end
end
