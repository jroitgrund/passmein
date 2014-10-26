class UsersController < ApplicationController

  before_action :unauthorized_if_logged_out, only: :update


  def login
    user = User.find_by_login(params[:login])
    if user and not params[:old_response]
      render json: {challenge: user.challenge}
    elsif user and params[:old_response] == user.response
      user.update(params.permit(:challenge, :response))
      session[:user_id] = user.id
      head :ok
    elsif not user
      create_user
    else
      head :unauthorized
    end
  end

  def logout
    session.delete(:user_id)
    head :ok
  end

  def update
    puts params[:details].map {|d| d[:id]}
    begin
      ActiveRecord::Base.transaction do
        if not current_user.details.update(
          params[:details].map {|d| d[:id]},
          params[:details].map{|d| d.except(:id)}).map{|d| d.valid?}.all?
          raise Exception
        else
          current_user.update(params.permit(:challenge, :response))
          head :ok
        end
      end
    rescue
      head :bad_request
    end
  end


  private
    def create_user
      begin
        user = User.new(params.permit(:login, :challenge, :response))
        user.save!
        session[:user_id] = user.id
        head :created
      rescue
        head :bad_request
      end
    end
end