class RegistrationsController < ApplicationController
  def signup
    user = User.new(
      email: params[:user][:email],
      password: params[:user][:password],
      is_admin: params[:user][:admin]
    )

    if user.save
      session[:user_id] = user.id
      render json: { status: 201, user: user.as_json(only: [:id, :email]) }
    else 
      render json: { status: 400, errors: user.errors.full_messages }
    end
  end
end
