module Opinion
	class Poll < ActiveRecord::Base
		has_many :options, :class_name => 'Opinion::Option', :dependent => :destroy

		validates :view, :presence => true, :uniqueness => true
		validates :question, :presence => true
		validates :options, :presence => true

		accepts_nested_attributes_for :options
	end
end
