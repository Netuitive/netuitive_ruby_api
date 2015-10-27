require 'netuitive/api_emissary'
require 'netuitive/ingest_metric'
require 'netuitive/ingest_sample'
require 'netuitive/ingest_element'
require 'netuitive/ruby_config_manager'

class MetricAggregator

	def initialize()
		@metrics=Array.new
		@samples=Array.new
		@aggregatedMetrics=Array.new
		@aggregatedSamples=Hash.new
		@metricMutex=Mutex.new
		@configManager=ConfigManager.new
		@apiEmissary=APIEmissary.new(@configManager.apiId, @configManager.baseAddr, @configManager.port)
	end

	def sendMetrics()
		@metricMutex.synchronize{
			if @metrics.empty?
				if @configManager.isInfo?
					puts "no netuitive metrics to report"
				end
				return
			end
			aggregatedSamplesArray = @aggregatedSamples.values
			aggregatedSamplesArray.each do |sample|
				sample.timestamp=Time.new
			end
			element=IngestElement.new(@configManager.elementName, @configManager.elementName, "custom", nil, @metrics+@aggregatedMetrics, @samples+aggregatedSamplesArray, nil, nil)
			elements= [element]
			@apiEmissary.sendElements(elements)
			clearMetrics
		}
	end

	def addSample(metricId, val)
		@metricMutex.synchronize{
			if not metricExists metricId
				metric=IngestMetric.new(metricId, metricId, nil, "custom", nil, false)
				@metrics.push(metric)
			end
			sample=IngestSample.new(metricId, Time.new, val, nil, nil, nil, nil, nil)
			@samples.push(sample)
			if @configManager.isInfo?
				puts "netuitive sample added #{metricId} val: #{val}"
			end
		}
	end

	def metricExists(metricId)
		@metrics.each do |metric|
				if metric.id == metricId
					return true
				end
			end
		return false
	end

	def aggregateMetric(metricId, val)
		@metricMutex.synchronize{
			if not metricExists metricId
				metric=IngestMetric.new(metricId, metricId, nil, "custom", nil, false)
				@metrics.push(metric)
				sample=IngestSample.new(metricId, Time.new, val, nil, nil, nil, nil, nil)
				@aggregatedSamples["#{metricId}"]=sample
			else
				sample=@aggregatedSamples["#{metricId}"]
				sample.val+=val
				@aggregatedSamples["#{metricId}"]=sample
			end
		}
	end

	def clearMetrics
		@metrics=Array.new
		@samples=Array.new
		@aggregatedSamples=Hash.new
	end
end