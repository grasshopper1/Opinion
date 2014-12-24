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
				redirect_to polls_url, alert: t('.already_voted')
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
				redirect_to @poll, notice: t('.created')
			else
				render action: 'new'
			end
		end

		# PATCH/PUT /polls/1
		def update
			if @poll.update(reset_destroy(poll_params))
				redirect_to @poll, notice: t('.updated')
			else
				render action: 'edit'
			end
		end

		# DELETE /polls/1
		def destroy
			@poll.destroy
			redirect_to polls_url, notice: t('.destroyed')
		end

		# POST /polls/1/end
		def end
			set_poll
			@poll.state = 'ended'

			if @poll.save
				redirect_to polls_url, notice: t('.ended')
			else
				redirect_to polls_url, alert: t('.not_ended')
			end
		end

		# POST /polls/1/activate
		def activate
			set_poll

			if !Opinion.configuration.end_poll_on_activate && !Opinion::Poll.active.empty?
				redirect_to(polls_url, alert: t('.not_ended_activated')) && return
			elsif !Opinion::Poll.active.empty?
				# End active poll.
				active_poll = Opinion::Poll.active.first
				active_poll.state = 'ended'
				active_poll.save
			end

			# Activate selected poll.
			@poll.state = 'active'

			if @poll.save
				redirect_to polls_url, notice: t('.activated')
			else
				redirect_to polls_url, notice: t('.not_actived')
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

		def add_waiting_time
			Rails.logger.debug { 'add_waiting_time called!' }
			Rails.logger.debug { "seen waiting times: #{session[:waiting_times].inspect}"}

			respond_to do |format|
				format.json do
					date_time = Time.now + Opinion.configuration.vote_later_wait.to_i
					current_waiting_time = waiting_time
					if current_waiting_time.nil?
						session[:waiting_times] ||= {}
						session[:waiting_times][opinion_user.id] = date_time
						Rails.logger.debug { "setting waiting time to: #{date_time}" }
					else
						Rails.logger.debug { "retrieved date time: #{current_waiting_time} (#{current_waiting_time.class}) from session" }
						if current_waiting_time - date_time > 0
							Rails.logger.debug { 'not setting new ttl, because old ttl is greater than new ttl' }
						else
							Rails.logger.debug { "setting waiting time to: #{date_time}" }
							session[:waiting_times][opinion_user.id] = date_time
						end
					end
					render :json => {}.as_json
				end
			end
		end

		def waiting_times
			respond_to do |format|
				format.json do
					# Waiting times with time as an unix-timestamp integer.
					waiting_times_hash = Hash[session[:waiting_times].map { |id,waiting_time| [id,waiting_time.to_time.to_i] }]
					now = Time.now.to_i
					waiting_times_diffs = Hash[waiting_times_hash.map { |id,waiting_time_int| [id,waiting_time_int - now] }]
					if opinion_user
						render :json => waiting_times_diffs[opinion_user.id]
					else
						render :json => waiting_times_diffs.as_json
					end
				end
			end
		end

		def show_poll
			respond_to do |format|
				format.json do
					render :json => opinion_show_poll?.as_json
				end
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

		# Used to process params after an update action fails,
		# To remove an option the _destroy key with value '1' is supplied.
		# If after an failed update because of a destroy too many,
		# the _destroy key is supplied with the value 'true', this method resets the value to 'false'.
		#
		# @param [ActionController::Parameters] params Parameters supplied to the update action.
		#
		# @return [ActionController::Parameters] Updated parameters.
		def reset_destroy(params)
			Hash[params.map do |l1_key, l1_val|
				Rails.logger.debug { "Seen: #{l1_key} -> #{l1_val} (#{l1_val.class})"}
				if l1_val.instance_of?(ActionController::Parameters)
					[l1_key, reset_destroy(l1_val)]
				elsif l1_key == '_destroy' && l1_val == 'true'
					[l1_key, 'false']
				else
					[l1_key, l1_val]
				end
			end]
		end
	end
end
