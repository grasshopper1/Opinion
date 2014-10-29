module Opinion
	class Option < ActiveRecord::Base
		belongs_to :opinion_poll, :class_name => 'Opinion::Poll'

		validates :description, :presence => true
	end
end
