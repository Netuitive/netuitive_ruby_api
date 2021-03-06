Netuitive Ruby API
===================

The Netuitive Ruby API provides an easy interface to communicate with the Netuitive Ruby daemon [NetuitiveD](https://rubygems.org/gems/netuitived). NetuitiveD is meant to work in conjunction with NetuitiveD and the [netuitive_rails_agent](https://rubygems.org/gems/netuitive_rails_agent) gem to help [Netuitive](https://www.netuitive.com) monitor your Ruby applications.

For more information on the Netuitive Ruby API, see our Ruby agent [help docs](https://help.netuitive.com/Content/Misc/Datasources/new_ruby_datasource.htm), or contact Netuitive support at [support@netuitive.com](mailto:support@netuitive.com).

Requirements
-------------

[NetuitiveD](https://github.com/Netuitive/netuitived) must be installed and running.

Installing the Netuitive Ruby API
----------------------------------

`gem install netuitive_ruby_api`

Using the Netuitive Ruby API
-----------------------------

Single sample example:

    NetuitiveRubyAPI::netuitivedServer.addSample("metric.name", [metric value])

Add the aggregation value to the existing value for the metric for this interval:

    NetuitiveRubyAPI::netuitivedServer.aggregateMetric("metric.name", [aggregation value])

An aggregation value is the sum of metric values over the course of a single interval. Aggregation can be quite useful for datasets like the number of requests per minute.

### Test

To run the tests and code syntax validation run the following commands:

```
gem install bundle
bundle install
bundle exec rubocop
bundle exec rake test
```

### Docker

This project can be tested and built in a Docker container for convenience. To build and run execute the following:

```
docker build -t netuitive/ruby-api .
docker run --name ruby-api netuitive/ruby-api
docker cp ruby-api:/opt/app/netuitive_ruby_api-<version>.gem .
```

Make sure to replace `<version>` with the version of the gem which was built in the container.
