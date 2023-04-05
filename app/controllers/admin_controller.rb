class AdminController < ApplicationController
  before_action :admin?

  def logs
    if params[:query].present?
      @pagy, @logs = pagy(Log.search_by_user_or_action(params[:query]))
    else
      @pagy, @logs = pagy(Log.order(created_at: :desc))
    end
  end

  def users
    if params[:query].present?
      @pagy, @users = pagy(User.search_by_username_or_email(params[:query]))
    else
      @pagy, @users = pagy(User.order(created_at: :desc))
    end
  end

  def edit_user
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:valided, :admin)
  end
end
