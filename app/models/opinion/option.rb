module Opinion
	class Option < ActiveRecord::Base
		belongs_to :poll, :class_name => 'Opinion::Poll'

		acts_as_voteable

		validates :description, :presence => true
	end
end
