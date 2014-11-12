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
	s.require_paths = ['lib']

	s.add_dependency 'rails'
	s.add_dependency 'chartkick'
	s.add_dependency 'gruff'

	s.add_runtime_dependency('statistics2')
	s.add_development_dependency('simplecov')
	s.add_development_dependency('devise')
	s.add_development_dependency('bundler')
	s.add_development_dependency('mysql2')
	s.add_development_dependency('pg')
	s.add_development_dependency('sqlite3')
	s.add_development_dependency('rake')
end
