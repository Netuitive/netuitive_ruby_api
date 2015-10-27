Gem::Specification.new do |s|
  s.name        = 'netuitive_ruby_api'
  s.version     = '0.9.0'
  s.date        = '2015-10-26'
  s.summary     = "Allows submitting metrics to Netuitive's API"
  s.description = "temp description"
  s.authors     = ["John King"]
  s.email       = 'jking@netuitive.com'
  files = Dir['lib/**/*.{rb}'] + Dir['lib/*.{rb}'] + Dir['config/*.{yml}']
  s.files       = files
  s.homepage    =
    'http://rubygems.org/gems/netuitive_ruby_api'
  s.license       = 'Apache v2.0'
end
