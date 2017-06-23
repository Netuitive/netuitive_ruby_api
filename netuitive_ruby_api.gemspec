Gem::Specification.new do |s|
  s.name        = 'netuitive_ruby_api'
  s.version     = '1.1.1'
  s.date        = '2017-06-23'
  s.summary     = "Interface for Netuitive's metric ingest API"
  s.description = 'Allows for easy submittion of metrics to Netuitive'
  s.authors     = ['John King']
  s.email       = 'jking@netuitive.com'
  files = Dir['lib/**/*.{rb}'] + Dir['lib/*.{rb}'] + Dir['config/*.{yml}'] + Dir['./LICENSE'] + Dir['log/*'] + Dir['./README.md']
  s.files       = files
  s.homepage    =
    'http://rubygems.org/gems/netuitive_ruby_api'
  s.license = 'Apache-2.0'
  s.required_ruby_version = '>= 1.9.0'
  s.add_development_dependency 'netuitived', '>= 1.1.0'
end
