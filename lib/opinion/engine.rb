# Enable warnings / verbosity by setting environment variable DEBUG.
module Opinion
	class Engine < ::Rails::Engine
		engine_name 'opinion'

		isolate_namespace Opinion

		initializer 'opinion.assets.precompile' do |app|
			app.config.assets.precompile += %w(application.css application.js options.css options.js polls.css polls.js)
			# use a proc instead of a string
			if Opinion.configuration.charts_engine == :highcharts
				STDERR.puts "Seen highcharts in config of opinion, adding #{Opinion.configuration.charts_engine_location} to path" if ENV['DEBUG']
				app.config.assets.precompile << Proc.new{|path| path == Opinion.configuration.charts_engine_location }
			else
				STDERR.puts 'NOT seen (a valid) highcharts config in opinion.' if ENV['DEBUG']
			end
		end

		['nested_form','jquery-rails','chartkick'].each do |gem|
			begin
				require gem
			rescue LoadError
				STDERR.puts "Unable to load #{gem} for #{engine_name}" if ENV['DEBUG']
			end
		end
	end
end
