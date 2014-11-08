module Opinion
	module PollsHelper
		# TODO Add description.
		def show_edit?(polls)
			polls.map { |poll| poll.voted? }.include?(false)
		end

		# TODO Add description.
		def show_activate?
			Opinion.configuration.end_poll_on_activate || Opinion::Poll.active.empty?
		end
	end
end
