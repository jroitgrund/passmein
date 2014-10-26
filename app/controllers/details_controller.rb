class DetailsController < ApplicationController

  before_action :unauthorized_if_logged_out

  def index
    render json: current_user.details.order("lower(site)").to_a
  end

  def create
    begin
      current_user.details.create!(params.permit(:site, :data))
      head :created
    rescue
      head :bad_request
    end
  end

  def update
    begin
      current_user.details.find(params[:id]).update(params.permit(:site, :data))
      head :ok
    rescue
      head :bad_request
    end
  end

  def destroy
    begin
      current_user.details.destroy(params[:id])
      head :ok
    rescue
      head :bad_request
    end
  end

end