module Opinion
	class Engine < ::Rails::Engine
		engine_name 'opinion'

		isolate_namespace Opinion

		['nested_form','jquery-rails','chartkick'].each do |gem|
			begin
				require gem
			rescue LoadError
				STDERR.puts "Unable to load #{gem} for #{engine_name}"
			end
		end
	end
end
