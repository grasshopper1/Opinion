require "opinion/engine"

# Copied from thumbs_up gem
require 'acts_as_voteable'
require 'acts_as_voter'
require 'has_karma'
require 'opinion/configuration'
require 'opinion/base'
require 'opinion/version'

module Opinion
	class << self

		# An Opinion::Configuration object. Must act like a hash and return sensible
		# values for all Opinion::Configuration::OPTIONS. See Opinion::Configuration.
		attr_writer :configuration

		# Call this method to modify defaults in your initializers.
		#
		# @example
		#   ThumbsUp.configure do |config|
		#     config.voteable_relationship_name = :votes_on
		#     config.voter_relationship_name    = :votes_by
		#   end
		def configure
			yield(configuration)
		end

		# The configuration object.
		# @see Opinion::Configuration
		def configuration
			@configuration ||= Configuration.new
		end
	end
end

ActiveRecord::Base.send(:include, Opinion::ActsAsVoteable)
ActiveRecord::Base.send(:include, Opinion::ActsAsVoter)
ActiveRecord::Base.send(:include, Opinion::Karma)
