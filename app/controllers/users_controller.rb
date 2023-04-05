class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create]
  def create
    @user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"])
  	session[:user_id] = @user.id
  	redirect_to root_path, notice: "Vous êtes connecté."
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path, notice: "Votre profil a été mis à jour."
    else
      render :edit
    end
  end

  def delete
    session[:user_id] = nil
    redirect_to root_path, notice: "Vous êtes déconnecté."
  end

  private

  def user_params
    params.require(:user).permit(:valided, :admin)
  end

end
