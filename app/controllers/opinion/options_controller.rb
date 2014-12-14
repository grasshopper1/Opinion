require_dependency 'opinion/application_controller'

module Opinion
	class OptionsController < ApplicationController
		before_action :set_option, only: [:show, :edit, :update, :destroy]

		# GET /options
		def index
			@options = Option.all
		end

		# GET /options/1
		def show
		end

		# GET /options/new
		def new
			@option = Option.new
		end

		# GET /options/1/edit
		def edit
		end

		# POST /options
		def create
			@option = Option.new(option_params)

			if @option.save
				redirect_to @option, notice: t('.created')
			else
				render action: 'new'
			end
		end

		# PATCH/PUT /options/1
		def update
			if @option.update(option_params)
				redirect_to @option, notice: t('.updated')
			else
				render action: 'edit'
			end
		end

		# DELETE /options/1
		def destroy
			@option.destroy
			redirect_to options_url, notice: t('.destroyed')
		end

		# GET options/1/vote_up.
		def vote_up
			begin
				set_option
				if @option.poll.voted_by?(opinion_user)
					Rails.logger.warn { "already voted by #{opinion_user}" }
					# TODO add flash message
					# render :nothing => true, :status => 200
					redirect_to :back
				else
					Rails.logger.debug { "#{opinion_user} voting for option #{@option}" }
					# everything seems fine, let's vote
					opinion_user.vote_for(@option)
					# render :nothing => true, :status => 200
					redirect_to :back
				end
			rescue ActiveRecord::RecordInvalid
				# render :nothing => true, :status => 404
				redirect_to :back
			end
		end

		private
		# Use callbacks to share common setup or constraints between actions.
		def set_option
			@option = Option.find(params[:id])
		end

		# Only allow a trusted parameter "white list" through.
		def option_params
			params.require(:option).permit(:description, :poll_id)
		end
	end
end
