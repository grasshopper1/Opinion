module Opinion
	class Poll < ActiveRecord::Base
		has_many :options, :class_name => 'Opinion::Option', :dependent => :destroy

		validates :state, :presence => true
		validates :state, :inclusion => %w(active pending ended)
		validates :question, :presence => true

		validates :options, :presence => true
		validate :at_least_two_options

		accepts_nested_attributes_for :options

		scope :active, -> { where state: 'active' }
		scope :pending, -> { where state: 'pending' }
		scope :ended,  -> { where state: 'ended' }

		# TODO Comment me.
		def at_least_two_options
			if options.size < 2
				self.errors.add(:options, 'at least two must be defined')
			end
		end

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

		# TODO Comment me.
		def options_chart_data
			Hash[options.map { |option| [option.description, option.votes_for]}]
		end
	end
end
