Gem::Specification.new do |s|
  s.name        = 'netuitive_ruby_api'
  s.version     = '1.0.1'
  s.date        = '2016-10-17'
  s.summary     = "Interface for Netuitive's metric ingest API"
  s.description = 'Allows for easy submittion of metrics to Netuitive'
  s.authors     = ['John King']
  s.email       = 'jking@netuitive.com'
  files = Dir['lib/**/*.{rb}'] + Dir['lib/*.{rb}'] + Dir['config/*.{yml}'] + Dir['./LICENSE'] + Dir['log/*'] + Dir['./README.md']
  s.files       = files
  s.homepage    =
    'http://rubygems.org/gems/netuitive_ruby_api'
  s.license = 'Apache v2.0'
  s.required_ruby_version = '>= 1.9.0'
end
