module Opinion
	class Configuration

		OPTIONS = [:voteable_relationship_name, :voter_relationship_name, :helpers_to_application, :user_getter, :end_poll_on_activate,
		           :charts_engine].freeze

		# Specify the name of the relationship from voted on things to voters.
		# Default is votes
		# In order to have a model that votes on itself,
		#   e.g. Users vote on Users,
		#   must change :voteable_relationship_name or :voter_relationship_name
		#   to a non-default value
		attr_accessor :voteable_relationship_name

		# Specify the name of the relationship from voters to voted on things
		# Default is votes
		# In order to have a model that votes on itself,
		#   e.g. Users vote on Users,
		#   must change :voteable_relationship_name or :voter_relationship_name
		#   to a non-default value
		attr_accessor :voter_relationship_name

		# TODO Add description.
		attr_accessor :helpers_to_application

		# TODO Add description.
		attr_accessor :user_getter

		# TODO Add description.
		attr_accessor :end_poll_on_activate

		# TODO Add description.
		attr_accessor :charts_engine

		# TODO Add description
		attr_accessor :charts_engine_location

		def initialize
			# these defaults can be overridden in the ThumbsUp.config block
			@voteable_relationship_name    = :votes
			@voter_relationship_name       = :votes
			@helpers_to_application        = true
			@user_getter                   = :current_user
			@end_poll_on_activate          = false
			@charts_engine                 = :google_charts
			@charts_engine_location        = '//www.google.com/jsapi'
		end

		# Allows config options to be read like a hash
		#
		# @param [Symbol] option Key for a given attribute
		def [](option)
			send(option)
		end

		# Returns a hash of all configurable options
		def to_hash
			OPTIONS.inject({}) do |hash, option|
				hash[option.to_sym] = self.send(option)
				hash
			end
		end

		# Returns a hash of all configurable options merged with +hash+
		#
		# @param [Hash] hash A set of configuration options that will take precedence over the defaults
		def merge(hash)
			to_hash.merge(hash)
		end

	end
end
