module Opinion
	module ControllerHelper
		# Used to retrieve user object used to check for votes.
		#
		# @return [ActiveRecord::Base] User object that is an active-record base object.
		#
		# @raise [RuntimeError] When opinion-user getter method specified in config does not exist.
		def opinion_user
			begin
				send(Opinion.configuration.user_getter.to_sym)
			rescue NoMethodError
				raise "Opinion-user getter specified in configuration (#{Opinion.configuration.user_getter}) is not a valid method"
			end
		end

		# TODO Implement me correctly
		def opinion_poll(*args)
			options = args.extract_options!.symbolize_keys
			poll_identifier = args.pop

			Rails.logger.debug { "Poll identifier: #{poll_identifier.inspect}" }
			Rails.logger.debug { "Other options: #{options.inspect}" }
			Rails.logger.debug { "opinion_user: #{opinion_user.inspect}" }

			if Opinion::Poll.active.empty?
				# TODO perhaps show whiny text when no active poll is seen / make this configurable
				render text: ''
			else
				poll = Opinion::Poll.active.first

				unless poll.voted_by?(opinion_user)
					# TODO Make modal configurable, maybe someone doesn't like pop-ups.
					render :file => 'opinion/polls/_poll_modal.html.erb', :locals => {:poll => poll}
				end
			end
		end
	end
end