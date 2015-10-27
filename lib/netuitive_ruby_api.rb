require 'netuitive/metric_aggregator'
class NetuitiveRubyAPI
	class << self
		def setup
			@@aggregator=MetricAggregator.new
		end 

		def aggregator
			return @@aggregator
		end
	end
end

NetuitiveRubyAPI.setup