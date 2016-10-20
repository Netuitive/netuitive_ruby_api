require 'test/unit'
require 'mocha/test_unit'
require 'netuitive_ruby_api'
require 'netuitive_ruby_api/config_manager'
require 'netuitive_ruby_api/netuitive_logger'
require 'netuitive_ruby_api/error_logger'
require 'netuitive_ruby_api/data_cache'
require 'netuitive_ruby_api/data_cache_interaction'
require 'netuitive_ruby_api/data_manager'
require 'netuitive_ruby_api/event_schedule'
require 'netuitive_ruby_api/sample_schedule'

module NetuitiveRubyApi
  class DataCacheTest < Test::Unit::TestCase
    def setup
      @data_cache = NetuitiveRubyApi::DataCacheInteraction.new
    end

    def test_add_sample
      count = @data_cache.add_sample(sample)
      assert_equal(count, 1)
      samples = @data_cache.clear_sample_cache
      assert_equal(samples[:samples], [sample])
      assert_equal(samples[:counter_samples], [])
      assert_equal(samples[:aggregate_metrics], [])
      assert_equal(samples[:aggregate_counter_metrics], [])
    end

    def test_add_counter_sample
      count = @data_cache.add_counter_sample(sample)
      assert_equal(count, 1)
      samples = @data_cache.clear_sample_cache
      assert_equal(samples[:samples], [])
      assert_equal(samples[:counter_samples], [sample])
      assert_equal(samples[:aggregate_metrics], [])
      assert_equal(samples[:aggregate_counter_metrics], [])
    end

    def test_add_aggregate_metric
      count = @data_cache.add_aggregate_metric(sample)
      assert_equal(count, 1)
      samples = @data_cache.clear_sample_cache
      assert_equal(samples[:samples], [])
      assert_equal(samples[:counter_samples], [])
      assert_equal(samples[:aggregate_metrics], [sample])
      assert_equal(samples[:aggregate_counter_metrics], [])
    end

    def test_add_aggregate_counter_metric
      count = @data_cache.add_aggregate_counter_metric(sample)
      assert_equal(count, 1)
      samples = @data_cache.clear_sample_cache
      assert_equal(samples[:samples], [])
      assert_equal(samples[:counter_samples], [])
      assert_equal(samples[:aggregate_metrics], [])
      assert_equal(samples[:aggregate_counter_metrics], [sample])
    end

    def test_add_event
      count = @data_cache.add_event(event)
      assert_equal(count, 1)
      events = @data_cache.clear_event_cache
      assert_equal(events[:events], [event])
      assert_equal(events[:exception_events], [])
    end

    def test_add_exception_event
      count = @data_cache.add_exception_event(exception_event)
      assert_equal(count, 1)
      events = @data_cache.clear_event_cache
      assert_equal(events[:events], [])
      assert_equal(events[:exception_events], [exception_event])
    end

    def test_sample_locks
      threads = []
      start_time = Time.new
      250.times { threads << Thread.new { @data_cache.add_sample(sample) } }
      250.times { threads << Thread.new { @data_cache.add_counter_sample(sample) } }
      250.times { threads << Thread.new { @data_cache.add_aggregate_metric(sample) } }
      250.times { threads << Thread.new { @data_cache.add_aggregate_counter_metric(sample) } }
      threads.each(&:join)
      end_time = Time.new
      assert((end_time - start_time) * 1000 < 500) # we should be able to chew through 1000 samples in 500 ms
      count = @data_cache.add_sample(sample)
      assert_equal(count, 1001)
      samples = @data_cache.clear_sample_cache
      assert_equal(samples[:samples].size, 251)
      assert_equal(samples[:counter_samples].size, 250)
      assert_equal(samples[:aggregate_metrics].size, 250)
      assert_equal(samples[:aggregate_counter_metrics].size, 250)
    end

    def test_event_locks
      threads = []
      start_time = Time.new
      500.times { threads << Thread.new { @data_cache.add_event(event) } }
      500.times { threads << Thread.new { @data_cache.add_exception_event(exception_event) } }
      threads.each(&:join)
      end_time = Time.new
      assert((end_time - start_time) * 1000 < 500) # we should be able to chew through 1000 events in 500 ms
      count = @data_cache.add_event(event)
      assert_equal(count, 1001)
      events = @data_cache.clear_event_cache
      assert_equal(events[:events].size, 501)
      assert_equal(events[:exception_events].size, 500)
    end

    def sample
      { metric_id: 'metric.id', val: 1 }
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
      { exception: RuntimeError.new,
        klass: RuntimeError.class,
        tags: [{ test_name: 'test value' }] }
    end
  end
end
