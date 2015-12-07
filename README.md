# netuitive_ruby_api
An easy interface to communicate with the netuitive ruby daemon netuitived(https://rubygems.org/gems/netuitived)

Requirements:
	netuitived must be running

How to install using gem:

run the command:

     gem install netuitive_ruby_api

How to use:

Single sample example:
NetuitiveRubyAPI::netuitivedServer.addSample("metric.name", [metric value])

Add the aggregation value to the existing value for the metric for this interval:
NetuitiveRubyAPI::netuitivedServer.aggregateMetric("metric.name", [aggregation value])

Aggregation may be confusing but at its heart it's a simple concept. It's basically a sum of the aggregation values over the course of a single interval; it's useful for datasets like the number of requests per minute.  