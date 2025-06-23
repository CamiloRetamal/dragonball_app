class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :not_found ]
  layout :determine_layout

  def not_found
    if current_user
      render status: :not_found
    else
      redirect_to login_path
    end
  end

  private

  def determine_layout
    current_user ? "application" : "auth"
  end
end
