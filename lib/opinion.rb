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
		#   Opinion.configure do |config|
		#     config.voteable_relationship_name = :votes_on
		#     config.voter_relationship_name    = :votes_by
		#   end
		def configure
			if block_given?
				yield(configuration)
			end

			if configuration.helpers_to_application
				opinion_for :application
			end
			# Load initializers
			require 'opinion/chartkick'
		end

		# The configuration object.
		# @see Opinion::Configuration
		def configuration
			@configuration ||= Configuration.new
		end

		# Used to add opinion functionality as methods in specified controllers and as helper methods.
		#
		# @example
		#   Opinion.opinion_for :application #=> Adds functionality as methods to ApplicationController and helper methods will be available.
		#
		# @param [Array<Symbol,Class,String>] Symbols or Classes or Strings representing the controllers to add functionality to,
		#                                     controllers can be specified using the name without the controller suffix when using symbols.
		def opinion_for(*resources)
			options = resources.extract_options!

			resources.each do |resource|
				if resource.instance_of?(Symbol) || resource.instance_of?(String)
					resource_string = resource.to_s
					unless resource_string.end_with?('controller')
						resource_string = resource_string.to_s + '_controller'
					end
					resource_klass = resource_string.classify.constantize
				elsif resource.instance_of?(Object)
					resource_klass = resource
				end
				resource_klass.send(:include, Opinion::ControllerHelper)
				if resource_klass.respond_to?(:helper)
					resource_klass.send(:helper, Opinion::ControllerHelper)
				else
					STDERR.puts "Unable to add opinion helper functionality for resource #{resource_klass}"
				end
			end
		end
	end
end

ActiveRecord::Base.send(:include, Opinion::ActsAsVoteable)
ActiveRecord::Base.send(:include, Opinion::ActsAsVoter)
ActiveRecord::Base.send(:include, Opinion::Karma)
