module NetuitiveRubyApi
  class DataManagerTest < Test::Unit::TestCase
    def setup
      @data_cache = mock
      @netuitived_server = mock
      @data_manager = NetuitiveRubyApi::DataManager.new
      @data_manager.data_cache = @data_cache
      @data_manager.netuitived_server = @netuitived_server
      @error = make_error
    end

    def test_add_sample
      sample_cache_disable
      @netuitived_server.expects(:addSample).once.with('metric.id', 1)
      thread = @data_manager.add_sample('metric.id', 1)
      thread.join

      sample_cache_enable
      sample_cache_size(10)
      @data_cache.expects(:add_sample).once.with(sample).returns(1)
      @data_manager.add_sample('metric.id', 1)

      sample_cache_enable
      sample_cache_size(1)
      @data_cache.expects(:add_sample).once.with(sample).returns(1)
      @data_cache.expects(:clear_sample_cache).once.returns(sample_cache)
      @netuitived_server.expects(:add_samples).once.with(sample_cache[:samples])
      @netuitived_server.expects(:add_counter_samples).once.with(sample_cache[:counter_samples])
      @netuitived_server.expects(:add_aggregate_metrics).once.with(sample_cache[:aggregate_metrics])
      @netuitived_server.expects(:add_aggregate_counter_metrics).once.with(sample_cache[:aggregate_counter_metrics])
      @data_manager.add_sample('metric.id', 1).each(&:join)
    end

    def test_add_counter_sample
      sample_cache_disable
      @netuitived_server.expects(:addCounterSample).once.with('metric.id', 1)
      thread = @data_manager.add_counter_sample('metric.id', 1)
      thread.join

      sample_cache_enable
      sample_cache_size(10)
      @data_cache.expects(:add_counter_sample).once.with(sample).returns(1)
      @data_manager.add_counter_sample('metric.id', 1)

      sample_cache_enable
      sample_cache_size(1)
      @data_cache.expects(:add_counter_sample).once.with(sample).returns(1)
      @data_cache.expects(:clear_sample_cache).once.returns(sample_cache)
      @netuitived_server.expects(:add_samples).once.with(sample_cache[:samples])
      @netuitived_server.expects(:add_counter_samples).once.with(sample_cache[:counter_samples])
      @netuitived_server.expects(:add_aggregate_metrics).once.with(sample_cache[:aggregate_metrics])
      @netuitived_server.expects(:add_aggregate_counter_metrics).once.with(sample_cache[:aggregate_counter_metrics])
      @data_manager.add_counter_sample('metric.id', 1).each(&:join)
    end

    def test_aggregate_metric
      sample_cache_disable
      @netuitived_server.expects(:aggregateMetric).once.with('metric.id', 1)
      thread = @data_manager.aggregate_metric('metric.id', 1)
      thread.join

      sample_cache_enable
      sample_cache_size(10)
      @data_cache.expects(:add_aggregate_metric).once.with(sample).returns(1)
      @data_manager.aggregate_metric('metric.id', 1)

      sample_cache_enable
      sample_cache_size(1)
      @data_cache.expects(:add_aggregate_metric).once.with(sample).returns(1)
      @data_cache.expects(:clear_sample_cache).once.returns(sample_cache)
      @netuitived_server.expects(:add_samples).once.with(sample_cache[:samples])
      @netuitived_server.expects(:add_counter_samples).once.with(sample_cache[:counter_samples])
      @netuitived_server.expects(:add_aggregate_metrics).once.with(sample_cache[:aggregate_metrics])
      @netuitived_server.expects(:add_aggregate_counter_metrics).once.with(sample_cache[:aggregate_counter_metrics])
      @data_manager.aggregate_metric('metric.id', 1).each(&:join)
    end

    def test_aggregate_counter_metric
      sample_cache_disable
      @netuitived_server.expects(:aggregateCounterMetric).once.with('metric.id', 1)
      thread = @data_manager.aggregate_counter_metric('metric.id', 1)
      thread.join

      sample_cache_enable
      sample_cache_size(10)
      @data_cache.expects(:add_aggregate_counter_metric).once.with(sample).returns(1)
      @data_manager.aggregate_counter_metric('metric.id', 1)

      sample_cache_enable
      sample_cache_size(1)
      @data_cache.expects(:add_aggregate_counter_metric).once.with(sample).returns(1)
      @data_cache.expects(:clear_sample_cache).once.returns(sample_cache)
      @netuitived_server.expects(:add_samples).once.with(sample_cache[:samples])
      @netuitived_server.expects(:add_counter_samples).once.with(sample_cache[:counter_samples])
      @netuitived_server.expects(:add_aggregate_metrics).once.with(sample_cache[:aggregate_metrics])
      @netuitived_server.expects(:add_aggregate_counter_metrics).once.with(sample_cache[:aggregate_counter_metrics])
      @data_manager.aggregate_counter_metric('metric.id', 1).each(&:join)
    end

    def test_event
      event_cache_disable
      @netuitived_server.expects(:event).once.with('test message',
                                                   Time.new(2000, 1, 1, 1, 1, 1),
                                                   'test title',
                                                   'test level',
                                                   'test source',
                                                   'test type',
                                                   [{ test_name: 'test value' }])
      thread = @data_manager.event('test message',
                                   Time.new(2000, 1, 1, 1, 1, 1),
                                   'test title',
                                   'test level',
                                   'test source',
                                   'test type',
                                   [{ test_name: 'test value' }])
      thread.join

      event_cache_enable
      event_cache_size(10)
      @data_cache.expects(:add_event).once.with(event).returns(1)
      @data_manager.event('test message',
                          Time.new(2000, 1, 1, 1, 1, 1),
                          'test title',
                          'test level',
                          'test source',
                          'test type',
                          [{ test_name: 'test value' }])

      event_cache_enable
      event_cache_size(1)
      @data_cache.expects(:add_event).once.with(event).returns(1)
      @data_cache.expects(:clear_event_cache).once.returns(event_cache)
      @netuitived_server.expects(:add_events).once.with(event_cache[:events])
      @netuitived_server.expects(:add_exception_events).once.with(event_cache[:exception_events])
      @data_manager.event('test message',
                          Time.new(2000, 1, 1, 1, 1, 1),
                          'test title',
                          'test level',
                          'test source',
                          'test type',
                          [{ test_name: 'test value' }]).each(&:join)
    end

    def test_exception_event
      event_cache_disable
      @netuitived_server.expects(:exceptionEvent).once.with({ message: @error.message, backtrace: @error.backtrace.join("\n\t") },
                                                            @error.class,
                                                            [{ test_name: 'test value' }])
      thread = @data_manager.exception_event(@error,
                                             @error.class,
                                             [{ test_name: 'test value' }])
      thread.join

      event_cache_enable
      event_cache_size(10)
      @data_cache.expects(:add_exception_event).once.with(exception_event).returns(1)
      @data_manager.exception_event(@error,
                                    @error.class,
                                    [{ test_name: 'test value' }])

      event_cache_enable
      event_cache_size(1)
      @data_cache.expects(:add_exception_event).once.with(exception_event).returns(1)
      @data_cache.expects(:clear_event_cache).once.returns(event_cache)
      @netuitived_server.expects(:add_events).once.with(event_cache[:events])
      @netuitived_server.expects(:add_exception_events).once.with(event_cache[:exception_events])
      @data_manager.exception_event(@error,
                                    @error.class,
                                    [{ test_name: 'test value' }]).each(&:join)
    end

    def sample_cache_enable
      @data_manager.sample_cache_enabled = true
    end

    def sample_cache_size(size)
      @data_manager.sample_cache_size = size
    end

    def sample_cache_disable
      @data_manager.sample_cache_enabled = false
    end

    def event_cache_enable
      @data_manager.event_cache_enabled = true
    end

    def event_cache_size(size)
      @data_manager.event_cache_size = size
    end

    def event_cache_disable
      @data_manager.event_cache_enabled = false
    end

    def sample
      { metric_id: 'metric.id', val: 1 }
    end

    def sample_cache
      { samples: [sample],
        counter_samples: [sample],
        aggregate_metrics: [sample],
        aggregate_counter_metrics: [sample] }
    end

    def event_cache
      { events: [event],
        exception_events: [exception_event] }
    end

    def make_error
      raise 'test exception'
    rescue => e
      return e
    end

    def event
      { message: 'test message',
        timestamp: Time.new(2000, 1, 1, 1, 1, 1),
        title: 'test title',
        level: 'test level',
        source: 'test source',
        type: 'test type',
        tags: [{ test_name: 'test value' }] }
    end

    def exception_event
      { exception: { message: @error.message, backtrace: @error.backtrace.join("\n\t") },
        klass: @error.class,
        tags: [{ test_name: 'test value' }] }
    end
  end
end
