class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  protected
    def logged_in?
      return session[:user_id]
    end

    def unauthorized_if_logged_out
      logged_in? or head :unauthorized
    end

    def current_user
      return User.find(session[:user_id])
    end
end
