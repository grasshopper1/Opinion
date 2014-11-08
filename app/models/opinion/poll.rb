module Opinion
	class Poll < ActiveRecord::Base
		has_many :options, :class_name => 'Opinion::Option', :dependent => :destroy

		validates :state, :presence => true
		validates :state, :inclusion => %w(active pending ended)
		validates :question, :presence => true
		# TODO at least two options need to be defined.
		validates :options, :presence => true

		accepts_nested_attributes_for :options

		scope :active, -> { where state: 'active' }
		scope :pending, -> { where state: 'pending' }
		scope :ended,  -> { where state: 'ended' }

		# TODO Comment me.
		def voted_by?(user)
			self.options.each do |option|
				if user.voted_for?(option)
					return true
				end
			end
			return false
		end

		# TODO Comment me.
		def voted?
			options.map { |option| option.votes_for }.inject(:+) > 0
		end
	end
end
