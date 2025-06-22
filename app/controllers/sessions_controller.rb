class SessionsController < ApplicationController
  layout "auth"
  skip_before_action :authenticate_user!

  def new
    redirect_to characters_path if current_user
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to characters_path
    else
      @email = params[:email]
      flash.now[:alert] = "Credenciales inválidas"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, status: :see_other
  end
end
