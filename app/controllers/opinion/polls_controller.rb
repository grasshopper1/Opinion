require_dependency 'opinion/application_controller'

module Opinion
	class PollsController < ApplicationController
		before_action :set_poll, only: [:show, :edit, :update, :destroy]

		# GET /polls
		def index
			@polls = Poll.all
		end

		# GET /polls/1
		def show
		end

		# GET /polls/new
		def new
			@poll = Poll.new
			@poll.options.build # add one option by default.
		end

		# GET /polls/1/edit
		def edit
			if @poll.voted?
				redirect_to polls_url, alert: 'Unable to edit poll which which has already voted for.'
			end
		end

		# POST /polls
		def create
			@poll = Poll.new(poll_params)

			# if no active polls exists set this one as active.
			if Opinion::Poll.active.empty?
				@poll.state = 'active'
			else
				@poll.state = 'pending'
			end

			if @poll.save
				redirect_to @poll, notice: 'Poll was successfully created.'
			else
				render action: 'new'
			end
		end

		# PATCH/PUT /polls/1
		def update
			if @poll.update(poll_params)
				redirect_to @poll, notice: 'Poll was successfully updated.'
			else
				render action: 'edit'
			end
		end

		# DELETE /polls/1
		def destroy
			@poll.destroy
			redirect_to polls_url, notice: 'Poll was successfully destroyed.'
		end

		# POST /polls/1/end
		def end
			set_poll
			@poll.state = 'ended'

			if @poll.save
				redirect_to @poll, notice: 'Poll was successfully ended.'
			else
				redirect_to polls_url, alert: 'Unable to end poll.'
			end
		end

		# POST /polls/1/activate
		def activate
			set_poll

			if !Opinion.configuration.end_poll_on_activate && !Opinion::Poll.active.empty?
				redirect_to(polls_url, alert: 'Unable to end activated poll.') && return
			elsif !Opinion::Poll.active.empty?
				# End active poll.
				active_poll = Opinion::Poll.active.first
				active_poll.state = 'ended'
				active_poll.save
			end

			# Activate selected poll.
			@poll.state = 'active'

			if @poll.save
				redirect_to polls_url, notice: 'Poll was successfully activated.'
			else
				redirect_to polls_url, notice: 'Unable to activate poll.'
			end
		end

		# POST /polls/1/vote_up
		def vote_up
			set_poll
			if @poll.voted_by?(opinion_user)
				Rails.logger.info { 'already voted by user' }
				# render :nothing => true, :status => 200
				redirect_to :back
			else
				Rails.logger.info { 'Not yet voted by user' }
				option = Opinion::Option.find(params[:voted_option])
				redirect_to opinion.vote_up_poll_option_url(@poll,option), :method => :post
			end
		end

		private
		# Use callbacks to share common setup or constraints between actions.
		def set_poll
			@poll = Poll.find(params[:id])
		end

		# Only allow a trusted parameter "white list" through.
		def poll_params
			params.require(:poll).permit(:question, options_attributes: [:id, :description, :_destroy])
		end
	end
end
