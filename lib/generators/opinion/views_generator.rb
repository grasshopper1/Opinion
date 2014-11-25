module Opinion
	class ViewsGenerator < Rails::Generators::Base
		desc 'This generator creates default views for opinion.'

		source_root File.expand_path('../../../../app/views', __FILE__)

		def create_views_generator
			directory('opinion',Rails.root.join('app/views/opinion'))
		end
	end
end