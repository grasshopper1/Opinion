$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'opinion/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
	s.name        = 'opinion'
	s.version     = Opinion::VERSION
	s.authors     = ['Haiko Bleumink']
	s.email       = ['haikobleumink@hotmail.com']
	s.homepage    = 'http://github.com/grasshopper1'
	s.summary     = 'Used for creating polls and gather opinions ;)'
	s.description = 'Create polls and gather opinions of users.'

	s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
	s.test_files = Dir['test/**/*']

	s.add_dependency 'rails', '~> 4.0.3'

	s.add_development_dependency 'sqlite3'
end
