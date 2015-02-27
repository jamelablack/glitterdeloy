class StatusesController < ApplicationController
	before_action :require_user, only: [:new, :create, :retweet]

	def new
		@status = Status.new
	end


	def create
		@status = Status.new(status_params)
		#user = User.find 1 #TODO Add Authentication
		@status.creator = current_user #TODO Add Authentication

		if @status.save
			flash[:notice] = "Status created!"
			redirect_to user_path(@status.creator.username)
		else
			render :new
		end
	end

	def index
		@statuses = Status.all
	end

	def show
		@status = Status.find(params[:id])
	end
	

	def retweet
		status = Status.find(params[:id])
		new_status = Status.new(body: status.body, creator: current_user, parent_status: status)

		if new_status.save
			flash[:notice] = "Retweeted!"
		else
			flash[:error] = "Couldn't retweet!"
		end
		redirect_to :back
	end

private

	def status_params
		params.require(:status).permit(:body)
	end
end