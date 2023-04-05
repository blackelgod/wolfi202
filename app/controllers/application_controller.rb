class ApplicationController < ActionController::Base
  before_action :authenticate
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :user_signed_in?
  include Pagy::Backend


  def authenticate
    redirect_to root_path, alert: "Connectez vous pour accéder à cette page." unless user_signed_in?
  end

  def admin?
    redirect_to root_path, alert: "Vous n'avez pas accès à cette page." unless current_user.admin
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end

  def user_signed_in?
    !!current_user
  end
end
