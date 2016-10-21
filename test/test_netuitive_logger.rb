module NetuitiveRubyApi
  class NetuitiveLoggerTest
    def test_format_age
      age = NetuitiveRubyApi::NetuitiveLogger.format_age('weekly')
      assert_equal(age, 'weekly')
      age = NetuitiveRubyApi::NetuitiveLogger.format_age(nil)
      assert_equal(age, 'daily')
      age = NetuitiveRubyApi::NetuitiveLogger.format_age(10)
      assert_equal(age, 10)
      age = NetuitiveRubyApi::NetuitiveLogger.format_age('10')
      assert_equal(age, 10)
    end

    def test_format_size
      size = NetuitiveRubyApi::NetuitiveLogger.format_size('weekly')
      assert_equal(size, 1_000_000)
      size = NetuitiveRubyApi::NetuitiveLogger.format_size(nil)
      assert_equal(size, 1_000_000)
      size = NetuitiveRubyApi::NetuitiveLogger.format_size(10)
      assert_equal(size, 10)
      size = NetuitiveRubyApi::NetuitiveLogger.format_size('10')
      assert_equal(size, 10)
    end
  end
end
