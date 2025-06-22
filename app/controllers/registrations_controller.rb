class RegistrationsController < ApplicationController
  layout "auth"
  skip_before_action :authenticate_user!

  def new
    redirect_to characters_path if current_user
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to characters_path, notice: "¡Bienvenido al mundo de Dragon Ball Z, #{@user.name}! Tu poder de pelea inicial ha sido registrado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
