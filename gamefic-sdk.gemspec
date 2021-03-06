$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require 'gamefic-sdk/version'

Gem::Specification.new do |s|
	s.name        = 'gamefic-sdk'
	s.version     = Gamefic::Sdk::VERSION
	s.date        = Date.today.strftime("%Y-%m-%d")
	s.summary     = "Gamefic SDK"
	s.description = "Development tools for Gamefic"
	s.authors     = ["Fred Snyder"]
	s.email       = 'fsnyder@gamefic.com'
	s.files       = ['lib/gamefic-sdk.rb'] + Dir['lib/gamefic-sdk/**/*.rb'] + Dir['html/**/*.rb'] + Dir['scripts/**/*.plot']
	s.executables << 'gfk'
	s.homepage    = 'http://gamefic.com'
	s.license     = 'MIT'
	s.required_ruby_version = '>= 1.9.3'
	s.add_runtime_dependency 'gamefic'
	s.add_runtime_dependency 'opal', [">= 0.7.2"]
	s.add_runtime_dependency 'slop'
	s.add_development_dependency 'rspec'
	s.add_development_dependency 'poltergeist'
end
