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
			waiting_time = waiting_time()

			Rails.logger.debug { "Poll identifier: #{poll_identifier.inspect}" }
			Rails.logger.debug { "Other options: #{options.inspect}" }
			Rails.logger.debug { "opinion_user: #{opinion_user.inspect}" }

			if !waiting_time.nil? && waiting_time - Time.now > 0
				Rails.logger.info { "NOT showing opinion-poll, because waiting time #{waiting_time.inspect} has not elapsed." }
				render text: ''
			elsif Opinion::Poll.active.empty?
				Rails.logger.info { 'NOT showing opinion-poll, because no active poll is available' }
				# TODO perhaps show whiny text when no active poll is seen / make this configurable
				render text: ''
			else
				poll = Opinion::Poll.active.first

				if poll.voted_by?(opinion_user)
					Rails.logger.info { 'NOT showing opinion-poll, because user already voted for poll' }
				else
					# TODO Make modal configurable, maybe someone doesn't like pop-ups.
					render :file => 'opinion/polls/_poll_modal.html.erb', :locals => {:poll => poll}
				end
			end
		end

		# @return [Time,nil]
		def waiting_time
			Rails.logger.debug { "retrieving waiting time for user #{opinion_user.inspect}" }
			session[:waiting_times] ||= {}
			if opinion_user && session[:waiting_times][opinion_user.id]
				if session[:waiting_times][opinion_user.id].instance_of?(Time)
					return session[:waiting_times][opinion_user.id]
				else
					Rails.logger.warn { "deleting current session value #{session[:waiting_times][opinion_user.id]} because it is not a Time" }
					session[:waiting_times].delete(opinion_user)
				end
			end
			return nil
		end

		# TODO Comment me
		def modal_tag(identifier, *args, &block)
			options = args.extract_options!.symbolize_keys

			options.merge!(:class => 'modal', :id => identifier.to_s)
			content_tag(:div, options, &block)
		end

		# TODO Comment me
		def vote_later_button(text)
			return unless Opinion.configuration.vote_later_type == :enable

			# <button type="button" class="btn btn-default" id="vote_later">Vote later</button>
			content_tag(:button, :class => 'btn btn-default', :id => 'vote_later') do
				text
			end
		end

		# Whether the poll should be displayed.
		#
		# @return [Boolean] Whether the poll should be displayed.
		def opinion_show_poll?
			begin
				!opinion_user.nil?
			rescue NoMethodError
				false
			end
		end
	end
end