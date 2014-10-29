require_dependency "opinion/application_controller"

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
        redirect_to @option, notice: 'Option was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /options/1
    def update
      if @option.update(option_params)
        redirect_to @option, notice: 'Option was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /options/1
    def destroy
      @option.destroy
      redirect_to options_url, notice: 'Option was successfully destroyed.'
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
