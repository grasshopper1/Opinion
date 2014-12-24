module Opinion
	class Poll < ActiveRecord::Base
		has_many :options, :class_name => 'Opinion::Option', :dependent => :destroy

		validates :state, :presence => true
		validates :state, :inclusion => %w(active pending ended)
		validates :question, :presence => true

		validates :options, :presence => true
		validate :at_least_two_options
		validate :unique_option_descriptions

		accepts_nested_attributes_for :options, :allow_destroy => true

		scope :active, -> { where state: 'active' }
		scope :pending, -> { where state: 'pending' }
		scope :ended,  -> { where state: 'ended' }

		# Needed for hidden field helper.
		attr_accessor :voted

		# TODO Comment me.
		def at_least_two_options
			if options.size < 2
				self.errors.add(:options, I18n.t("activerecord.errors.models.#{Opinion::Poll.model_name.i18n_key}.attributes.options.at_least_two",
				                            default: 'at least two options must be defined'))
			end
		end

		# TODO Comment me.
		def unique_option_descriptions
			unless options.map { |option| option.description } == options.map { |option| option.description }.uniq
				self.errors.add(:options, I18n.t("activerecord.errors.models.#{Opinion::Poll.model_name.i18n_key}.attributes.options.unique",
				                                 default: 'should be unique'))
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
